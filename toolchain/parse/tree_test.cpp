// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "toolchain/parse/tree.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include <forward_list>

#include "testing/base/test_raw_ostream.h"
#include "toolchain/base/yaml_test_helpers.h"
#include "toolchain/diagnostics/diagnostic_emitter.h"
#include "toolchain/diagnostics/mocks.h"
#include "toolchain/lex/tokenized_buffer.h"

namespace Carbon::Testing {
namespace {

using Parse::Tree;
using ::testing::ElementsAre;

class TreeTest : public ::testing::Test {
 protected:
  auto GetSourceBuffer(llvm::StringRef t) -> SourceBuffer& {
    CARBON_CHECK(fs.addFile("test.carbon", /*ModificationTime=*/0,
                            llvm::MemoryBuffer::getMemBuffer(t)));
    source_storage.push_front(
        std::move(*SourceBuffer::CreateFromFile(fs, "test.carbon")));
    return source_storage.front();
  }

  auto GetTokenizedBuffer(llvm::StringRef t) -> Lex::TokenizedBuffer& {
    token_storage.push_front(
        Lex::TokenizedBuffer::Lex(GetSourceBuffer(t), consumer));
    return token_storage.front();
  }

  llvm::vfs::InMemoryFileSystem fs;
  std::forward_list<SourceBuffer> source_storage;
  std::forward_list<Lex::TokenizedBuffer> token_storage;
  DiagnosticConsumer& consumer = ConsoleDiagnosticConsumer();
};

TEST_F(TreeTest, IsValid) {
  Lex::TokenizedBuffer tokens = GetTokenizedBuffer("");
  Tree tree = Tree::Parse(tokens, consumer, /*vlog_stream=*/nullptr);
  EXPECT_TRUE((*tree.postorder().begin()).is_valid());
}

TEST_F(TreeTest, PrintPostorderAsYAML) {
  Lex::TokenizedBuffer tokens = GetTokenizedBuffer("fn F();");
  Tree tree = Tree::Parse(tokens, consumer, /*vlog_stream=*/nullptr);
  EXPECT_FALSE(tree.has_errors());
  TestRawOstream print_stream;
  tree.Print(print_stream);

  auto file = Yaml::SequenceValue{
      Yaml::MappingValue{{"kind", "FunctionIntroducer"}, {"text", "fn"}},
      Yaml::MappingValue{{"kind", "Name"}, {"text", "F"}},
      Yaml::MappingValue{{"kind", "ParameterListStart"}, {"text", "("}},
      Yaml::MappingValue{
          {"kind", "ParameterList"}, {"text", ")"}, {"subtree_size", "2"}},
      Yaml::MappingValue{{"kind", "FunctionDeclaration"},
                         {"text", ";"},
                         {"subtree_size", "5"}},
      Yaml::MappingValue{{"kind", "FileEnd"}, {"text", ""}},
  };

  EXPECT_THAT(Yaml::Value::FromText(print_stream.TakeStr()), ElementsAre(file));
}

TEST_F(TreeTest, PrintPreorderAsYAML) {
  Lex::TokenizedBuffer tokens = GetTokenizedBuffer("fn F();");
  Tree tree = Tree::Parse(tokens, consumer, /*vlog_stream=*/nullptr);
  EXPECT_FALSE(tree.has_errors());
  TestRawOstream print_stream;
  tree.Print(print_stream, /*preorder=*/true);

  auto parameter_list = Yaml::SequenceValue{
      Yaml::MappingValue{
          {"node_index", "2"}, {"kind", "ParameterListStart"}, {"text", "("}},
  };

  auto function_decl = Yaml::SequenceValue{
      Yaml::MappingValue{
          {"node_index", "0"}, {"kind", "FunctionIntroducer"}, {"text", "fn"}},
      Yaml::MappingValue{{"node_index", "1"}, {"kind", "Name"}, {"text", "F"}},
      Yaml::MappingValue{{"node_index", "3"},
                         {"kind", "ParameterList"},
                         {"text", ")"},
                         {"subtree_size", "2"},
                         {"children", parameter_list}},
  };

  auto file = Yaml::SequenceValue{
      Yaml::MappingValue{{"node_index", "4"},
                         {"kind", "FunctionDeclaration"},
                         {"text", ";"},
                         {"subtree_size", "5"},
                         {"children", function_decl}},
      Yaml::MappingValue{
          {"node_index", "5"}, {"kind", "FileEnd"}, {"text", ""}},
  };

  EXPECT_THAT(Yaml::Value::FromText(print_stream.TakeStr()), ElementsAre(file));
}

TEST_F(TreeTest, HighRecursion) {
  std::string code = "fn Foo() { return ";
  code.append(10000, '(');
  code.append(10000, ')');
  code += "; }";
  Lex::TokenizedBuffer tokens = GetTokenizedBuffer(code);
  ASSERT_FALSE(tokens.has_errors());
  Testing::MockDiagnosticConsumer consumer;
  Tree tree = Tree::Parse(tokens, consumer, /*vlog_stream=*/nullptr);
  EXPECT_FALSE(tree.has_errors());
}

}  // namespace
}  // namespace Carbon::Testing
