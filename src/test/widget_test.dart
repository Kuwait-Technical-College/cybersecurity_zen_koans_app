import 'package:flutter_test/flutter_test.dart';
import 'package:cybersecurity_zen_koans/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const CybersecurityZenKoansApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('koan'), findsAny);
  });
}
