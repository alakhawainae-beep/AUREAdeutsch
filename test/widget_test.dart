import 'package:flutter_test/flutter_test.dart';

import 'package:aurea_deutsch/main.dart';

void main() {
  testWidgets('Home shows AUREA Deutsch branding and levels', (tester) async {
    await tester.pumpWidget(const AureaDeutschApp());
    await tester.pumpAndSettle();

    expect(find.text('AUREA'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('A2'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('C2'), 200);
    await tester.pumpAndSettle();

    expect(find.text('B1'), findsOneWidget);
    expect(find.text('B2'), findsOneWidget);
    expect(find.text('C1'), findsOneWidget);
    expect(find.text('C2'), findsOneWidget);
  });
}
