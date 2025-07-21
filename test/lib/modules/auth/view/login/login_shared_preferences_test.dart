import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insurance_company/modules/auth/view/login/login_page.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('should load saved login data', (tester) async {

    when(() => mockPrefs.getString('savedCpf')).thenReturn('12345678901');
    when(() => mockPrefs.getString('savedPassword')).thenReturn('senha123');

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (_, __) => const LoginPage(),
            );
          },
        ),
      ),
    );

    await tester.pump();
    final cpfField = tester.widget<TextField>(find.byType(TextField).at(0));
    final passwordField = tester.widget<TextField>(find.byType(TextField).at(1));

    expect(cpfField.controller?.text, '12345678901');
    expect(passwordField.controller?.text, 'senha123');
  });
}