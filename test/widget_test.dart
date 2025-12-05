import 'package:flutter_test/flutter_test.dart';

import 'package:hopefully_last/main.dart';

void main() {
  testWidgets('Login screen renders hero copy', (WidgetTester tester) async {
    await tester.pumpWidget(const LqithaApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(
      find.text('Sign in to continue to LQitha'),
      findsOneWidget,
    );
  });
}
