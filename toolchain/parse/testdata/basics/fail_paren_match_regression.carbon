// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

// CHECK:STDERR: fail_paren_match_regression.carbon:[[@LINE+6]]:5: Expected pattern in `var` declaration.
// CHECK:STDERR: var = (foo {})
// CHECK:STDERR:     ^
// CHECK:STDERR: fail_paren_match_regression.carbon:[[@LINE+3]]:12: Expected `,` or `)`.
// CHECK:STDERR: var = (foo {})
// CHECK:STDERR:            ^
var = (foo {})

// CHECK:STDERR: fail_paren_match_regression.carbon:[[@LINE+14]]:19: `var` declarations must end with a `;`.
// CHECK:STDERR: // CHECK:STDOUT: ]
// CHECK:STDERR:                   ^
// CHECK:STDOUT: [
// CHECK:STDOUT:   {kind: 'VariableIntroducer', text: 'var'},
// CHECK:STDOUT:     {kind: 'Name', text: '=', has_error: yes},
// CHECK:STDOUT:     {kind: 'InvalidParse', text: '=', has_error: yes},
// CHECK:STDOUT:   {kind: 'PatternBinding', text: '=', has_error: yes, subtree_size: 3},
// CHECK:STDOUT:   {kind: 'VariableInitializer', text: '='},
// CHECK:STDOUT:     {kind: 'ParenExpressionOrTupleLiteralStart', text: '('},
// CHECK:STDOUT:     {kind: 'NameExpression', text: 'foo'},
// CHECK:STDOUT:   {kind: 'ParenExpression', text: ')', has_error: yes, subtree_size: 3},
// CHECK:STDOUT: {kind: 'VariableDeclaration', text: 'var', has_error: yes, subtree_size: 9},
// CHECK:STDOUT: {kind: 'FileEnd', text: ''},
// CHECK:STDOUT: ]
