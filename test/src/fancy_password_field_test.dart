import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:fancy_password_field/src/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> loadWidget(
    WidgetTester tester, {
    required Widget widget,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );
  }

  testWidgets(
    'should build without exploding',
    (tester) async {
      await loadWidget(
        tester,
        widget: FancyPasswordField(
          key: UniqueKey(),
        ),
      );

      expect(find.byType(FancyPasswordField), findsOneWidget);
    },
  );

  testWidgets(
    'should build without exploding with decoration',
    (tester) async {
      await loadWidget(
        tester,
        widget: FancyPasswordField(
          key: UniqueKey(),
          decoration: const InputDecoration(),
        ),
      );

      expect(find.byType(FancyPasswordField), findsOneWidget);
    },
  );

  testWidgets(
    'pressing DefaultShowHidePasswordButton should show password',
    (tester) async {
      await loadWidget(
        tester,
        widget: const FancyPasswordField(),
      );

      final showHideButton = find.byType(DefaultShowHidePasswordButton);
      await tester.tap(showHideButton);
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField);
      await tester.enterText(passwordField, 'test');
      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
    },
  );

  testWidgets(
    'pressing DefaultShowHidePasswordButton with decoration should show password',
    (tester) async {
      await loadWidget(
        tester,
        widget: const FancyPasswordField(
          decoration: InputDecoration(),
        ),
      );

      final showHideButton = find.byType(DefaultShowHidePasswordButton);
      await tester.tap(showHideButton);
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextFormField);
      await tester.enterText(passwordField, 'test');
      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
    },
  );

  testWidgets(
    'should thrigger onChange if not null',
    (tester) async {
      await loadWidget(
        tester,
        widget: FancyPasswordField(
          onChanged: (value) {
            expect(value, 'test');
          },
        ),
      );

      final passwordField = find.byType(TextFormField);
      await tester.enterText(passwordField, 'test');
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'should thrigger onSaved and validator of form if not null',
    (tester) async {
      final _formKey = GlobalKey<FormState>();
      await loadWidget(
        tester,
        widget: Form(
          key: _formKey,
          child: Column(
            children: [
              FancyPasswordField(
                onSaved: (value) {
                  expect(value, 'test');
                },
                validator: (value) {
                  expect(value, 'test');
                  return;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                  _formKey.currentState!.save();
                },
                child: const Text('Form'),
              ),
            ],
          ),
        ),
      );

      final passwordField = find.byType(TextFormField);
      await tester.enterText(passwordField, 'test');
      await tester.pumpAndSettle();

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'should show ValidationRulesWidget if rules is not empty',
    (tester) async {
      await loadWidget(
        tester,
        widget: FancyPasswordField(
          validationRules: {
            UppercaseValidationRule(),
            LowercaseValidationRule(),
          },
        ),
      );

      expect(find.byType(ValidationRulesWidget), findsOneWidget);
    },
  );

  testWidgets(
    'should render hidePasswordWidget when provided',
    (tester) async {
      await loadWidget(
        tester,
        widget: const FancyPasswordField(
          hasShowHidePassword: true,
          hidePasswordWidget: Icon(Icons.visibility_off),
          // showPasswordWidget: Icon(Icons.visibility),
        ),
      );

      expect((tester.widget(find.byType(Icon)) as Icon).icon, Icons.visibility_off);
    },
  );

  testWidgets(
    'should render showPasswordWidget when provided',
    (tester) async {
      await loadWidget(
        tester,
        widget: const FancyPasswordField(
          hasShowHidePassword: true,
          hidePasswordWidget: Icon(Icons.visibility_off),
          showPasswordWidget: Icon(Icons.visibility),
        ),
      );

      await tester.tap(find.byType(Icon));

      await tester.pumpAndSettle();

      expect((tester.widget(find.byType(Icon)) as Icon).icon, Icons.visibility);
    },
  );

  testWidgets(
    'should fail if hidePasswordIcon and hidePasswordWidget are both provided',
    (tester) async {
      expect(() async {
        await loadWidget(
          tester,
          widget: FancyPasswordField(
            hasShowHidePassword: true,
            hidePasswordIcon: const Icon(Icons.visibility_off),
            hidePasswordWidget: const Icon(Icons.visibility_off),
          ),
        );
      }, throwsAssertionError);
    },
  );

  testWidgets(
    'should fail if showPasswordIcon and showPasswordWidget are both provided',
    (tester) async {
      expect(() async {
        await loadWidget(
          tester,
          widget: FancyPasswordField(
            hasShowHidePassword: true,
            showPasswordIcon: const Icon(Icons.visibility_off),
            showPasswordWidget: const Icon(Icons.visibility_off),
          ),
        );
      }, throwsAssertionError);
    },
  );

  testWidgets(
    'should trigger immediate validation if initialValue is provided',
    (tester) async {
      await loadWidget(
        tester,
        widget: FancyPasswordField(
          initialValue: 'Test',
          validationRules: {
            UppercaseValidationRule(),
          },
        ),
      );

      expect(((tester.widget(find.byType(Chip)) as Chip).label as Text).style?.color, Colors.green);
    },
  );

  testWidgets(
    'should trigger immediate validation if text editing controller with value is provided',
    (tester) async {
      await loadWidget(
        tester,
        widget: FancyPasswordField(
          controller: TextEditingController(text: 'Test'),
          validationRules: {
            UppercaseValidationRule(),
          },
        ),
      );

      expect(((tester.widget(find.byType(Chip)) as Chip).label as Text).style?.color, Colors.green);
    },
  );
}
