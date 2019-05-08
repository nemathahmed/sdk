// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(NotTest);
    defineReflectiveTests(NotWithNnbdTest);
  });
}

@reflectiveTest
class NotTest extends DriverResolutionTest {
  test_simple() async {
    addTestFile('''
void f(bool a) {
  var b = !a;
  print(b);
}
''');
    await resolveTestFile();
    assertType(findNode.simple('b)'), 'bool');
  }
}

@reflectiveTest
class NotWithNnbdTest extends NotTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = new FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  @override
  bool get typeToStringWithNullability => true;

  @failingTest
  @override
  test_simple() async {
    await super.test_simple();
  }
}
