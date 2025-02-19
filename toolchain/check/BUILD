# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

load("@rules_cc//cc:defs.bzl", "cc_library")
load("//bazel/sh_run:rules.bzl", "glob_sh_run")
load("//testing/file_test:rules.bzl", "file_test")
load("//testing/fuzzing:rules.bzl", "cc_fuzz_test")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "node_stack",
    srcs = ["node_stack.cpp"],
    hdrs = ["node_stack.h"],
    deps = [
        "//common:check",
        "//common:ostream",
        "//common:vlog",
        "//toolchain/parse:node_kind",
        "//toolchain/parse:tree",
        "//toolchain/sem_ir:node",
        "@llvm-project//llvm:Support",
    ],
)

cc_library(
    name = "check",
    srcs = [
        "check.cpp",
        "context.cpp",
        "declaration_name_stack.cpp",
        "node_block_stack.cpp",
    ] +
    # Glob handler files to avoid missing any.
    glob([
        "handle*.cpp",
    ]),
    hdrs = [
        "check.h",
        "context.h",
        "declaration_name_stack.h",
        "node_block_stack.h",
    ],
    deps = [
        ":node_stack",
        "//common:check",
        "//common:ostream",
        "//common:vlog",
        "//toolchain/base:pretty_stack_trace_function",
        "//toolchain/diagnostics:diagnostic_emitter",
        "//toolchain/diagnostics:diagnostic_kind",
        "//toolchain/lex:tokenized_buffer",
        "//toolchain/parse:node_kind",
        "//toolchain/parse:tree",
        "//toolchain/parse:tree_node_location_translator",
        "//toolchain/sem_ir:builtin_kind",
        "//toolchain/sem_ir:file",
        "//toolchain/sem_ir:node",
        "//toolchain/sem_ir:node_kind",
        "@llvm-project//llvm:Support",
    ],
)

file_test(
    name = "check_file_test",
    srcs = ["check_file_test.cpp"],
    tests = glob(["testdata/**/*.carbon"]),
    deps = [
        "//toolchain/driver:driver_file_test_base",
        "@llvm-project//llvm:Support",
    ],
)

cc_fuzz_test(
    name = "check_fuzzer",
    size = "small",
    srcs = ["check_fuzzer.cpp"],
    corpus = glob(["fuzzer_corpus/*"]),
    deps = [
        "//toolchain/driver",
        "@llvm-project//llvm:Support",
    ],
)

glob_sh_run(
    args = [
        "$(location //toolchain/driver:carbon)",
        "compile",
        "--phase=check",
        "--dump-semantics-ir",
        "--dump-raw-semantics-ir",
    ],
    data = ["//toolchain/driver:carbon"],
    file_exts = ["carbon"],
)

glob_sh_run(
    args = [
        "$(location //toolchain/driver:carbon)",
        "-v",
        "compile",
        "--phase=check",
    ],
    data = ["//toolchain/driver:carbon"],
    file_exts = ["carbon"],
    run_ext = "verbose",
)
