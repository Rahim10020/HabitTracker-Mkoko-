import 'package:R_HabitTracker/components/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppTextField renders hintText and accepts input',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'Enter a label',
          ),
        ),
      ),
    );

    expect(find.text('Enter a label'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(controller.text, isEmpty);

    await tester.enterText(find.byType(TextField), 'hello');
    expect(controller.text, 'hello');
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('AppTextField fires onChanged and obscures text',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    String? observed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'Secret',
            obscureText: true,
            onChanged: (value) => observed = value,
          ),
        ),
      ),
    );

    final tf = tester.widget(find.byType(TextField)) as TextField;
    expect(tf.obscureText, isTrue);

    await tester.enterText(find.byType(TextField), 'pw');
    expect(observed, 'pw');
  });

  testWidgets('AppTextField respects autofocus', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'Focused',
            autofocus: true,
          ),
        ),
      ),
    );

    final tf = tester.widget(find.byType(TextField)) as TextField;
    expect(tf.autofocus, isTrue);
  });

  testWidgets('AppTextField disables input when enabled=false',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'Disabled',
            enabled: false,
          ),
        ),
      ),
    );

    final tf = tester.widget(find.byType(TextField)) as TextField;
    expect(tf.enabled, isFalse);
  });
}
