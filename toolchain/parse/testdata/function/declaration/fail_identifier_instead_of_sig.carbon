// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

// CHECK:STDERR: fail_identifier_instead_of_sig.carbon:[[@LINE+3]]:8: `fn` requires a `(` for parameters.
// CHECK:STDERR: fn foo bar;
// CHECK:STDERR:        ^
fn foo bar;

// CHECK:STDOUT: [
// CHECK:STDOUT:   {kind: 'FunctionIntroducer', text: 'fn'},
// CHECK:STDOUT:   {kind: 'Name', text: 'foo'},
// CHECK:STDOUT: {kind: 'FunctionDeclaration', text: ';', has_error: yes, subtree_size: 3},
// CHECK:STDOUT: {kind: 'FileEnd', text: ''},
// CHECK:STDOUT: ]
