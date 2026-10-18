import 'package:flutter_test/flutter_test.dart';

import 'package:aurea_deutsch/main.dart';

void main() {
  testWidgets('Home shows branding and games', (tester) async {
    await tester.pumpWidget(const AureaDeutschApp());
    await tester.pumpAndSettle();

    expect(find.text('AUREA'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('Balloon Pop'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
    expect(find.text('Crossword'), findsOneWidget);
    expect(find.text('Image Guess'), findsOneWidget);
    expect(find.text('Memory'), findsOneWidget);
  });
}
