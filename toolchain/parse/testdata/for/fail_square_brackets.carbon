// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

fn F() {
  // CHECK:STDERR: fail_square_brackets.carbon:[[@LINE+12]]:7: Expected `(` after `for`.
  // CHECK:STDERR:   for [] {
  // CHECK:STDERR:       ^
  // CHECK:STDERR: fail_square_brackets.carbon:[[@LINE+9]]:7: Expected `var` declaration.
  // CHECK:STDERR:   for [] {
  // CHECK:STDERR:       ^
  // CHECK:STDERR: fail_square_brackets.carbon:[[@LINE+6]]:8: Expected expression.
  // CHECK:STDERR:   for [] {
  // CHECK:STDERR:        ^
  // CHECK:STDERR: fail_square_brackets.carbon:[[@LINE+3]]:8: Expected `;` in array type.
  // CHECK:STDERR:   for [] {
  // CHECK:STDERR:        ^
  for [] {
  }
}

// CHECK:STDOUT: [
// CHECK:STDOUT:     {kind: 'FunctionIntroducer', text: 'fn'},
// CHECK:STDOUT:     {kind: 'Name', text: 'F'},
// CHECK:STDOUT:       {kind: 'ParameterListStart', text: '('},
// CHECK:STDOUT:     {kind: 'ParameterList', text: ')', subtree_size: 2},
// CHECK:STDOUT:   {kind: 'FunctionDefinitionStart', text: '{', subtree_size: 5},
// CHECK:STDOUT:       {kind: 'ForHeaderStart', text: 'for', has_error: yes},
// CHECK:STDOUT:           {kind: 'ArrayExpressionStart', text: '['},
// CHECK:STDOUT:           {kind: 'InvalidParse', text: ']', has_error: yes},
// CHECK:STDOUT:         {kind: 'ArrayExpressionSemi', text: ']', has_error: yes, subtree_size: 3},
// CHECK:STDOUT:       {kind: 'ArrayExpression', text: ']', has_error: yes, subtree_size: 4},
// CHECK:STDOUT:     {kind: 'ForHeader', text: 'for', has_error: yes, subtree_size: 6},
// CHECK:STDOUT:       {kind: 'CodeBlockStart', text: '{'},
// CHECK:STDOUT:     {kind: 'CodeBlock', text: '}', subtree_size: 2},
// CHECK:STDOUT:   {kind: 'ForStatement', text: 'for', subtree_size: 9},
// CHECK:STDOUT: {kind: 'FunctionDefinition', text: '}', subtree_size: 15},
// CHECK:STDOUT: {kind: 'FileEnd', text: ''},
// CHECK:STDOUT: ]
