import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:insurance_company/shared/widgets/custom_login_text_field.dart';

void main() {
  testWidgets('CustomLoginTextField displays the label and hides text if obscureText is true', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomLoginTextField(
            controller: controller,
            label: 'Password',
            obscureText: true,
          ),
        ),
      ),
    );

    expect(find.text('Password'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'mysecret');
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);
  });
}
