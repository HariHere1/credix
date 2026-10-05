import 'package:flutter_test/flutter_test.dart';

import 'package:activity_points/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ActivityPointsApp());
    expect(find.text('CREDIX'), findsOneWidget);
  });
}
