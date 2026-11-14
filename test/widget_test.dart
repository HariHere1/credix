import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:activity_points/main.dart';
import 'package:activity_points/screens/student/account_tab.dart';
import 'package:activity_points/theme/app_theme.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ActivityPointsApp());
    expect(find.text('CREDIX'), findsOneWidget);
  });

  testWidgets('Student account FAQ fits at a narrow width',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const StudentAccountTab(),
      ),
    );

    expect(find.text('PROFILE'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final question = find.text('Why was my certificate flagged?');
    await tester.scrollUntilVisible(question, 150);
    await tester.tap(question);
    await tester.pumpAndSettle();

    expect(find.textContaining('extracted details need advisor review.'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
