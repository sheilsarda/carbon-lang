// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

// CHECK:STDERR: fail_args.carbon:[[@LINE+3]]:14: `namespace` declarations must end with a `;`.
// CHECK:STDERR: namespace Foo();
// CHECK:STDERR:              ^
namespace Foo();

// CHECK:STDOUT: [
// CHECK:STDOUT:   {kind: 'NamespaceStart', text: 'namespace'},
// CHECK:STDOUT:   {kind: 'Name', text: 'Foo'},
// CHECK:STDOUT: {kind: 'Namespace', text: ';', has_error: yes, subtree_size: 3},
// CHECK:STDOUT: {kind: 'FileEnd', text: ''},
// CHECK:STDOUT: ]
