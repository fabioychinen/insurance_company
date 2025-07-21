import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insurance_company/modules/auth/view/login/login_page.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_bloc.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_state.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  late MockLoginBloc mockBloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'savedCpf': '12345678901',
      'savedPassword': 'senha123',
    });

    mockBloc = MockLoginBloc();
    when(() => mockBloc.state).thenReturn(LoginInitial());
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(LoginInitial()));
  });

  testWidgets('should load saved login data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginBloc>.value(
          value: mockBloc,
          child: const LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final cpfField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);

    expect(tester.widget<TextField>(cpfField).controller?.text, '12345678901');
    expect(tester.widget<TextField>(passwordField).controller?.text, 'senha123');
  });
}