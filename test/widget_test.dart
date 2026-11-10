import 'package:flutter_test/flutter_test.dart';

import 'package:lab1_app/main.dart';

void main() {
  testWidgets('Menu shows both lab buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Lab 2 - Dart and null safety'), findsOneWidget);
    expect(find.text('Lab 3 - Todo app'), findsOneWidget);
  });
}
