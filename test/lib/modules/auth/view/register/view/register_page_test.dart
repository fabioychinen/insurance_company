import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_company/modules/auth/view/register/register_page.dart';
import 'package:insurance_company/shared/widgets/custom_text_field.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/modules/auth/viewmodel/register/register_bloc.dart';
import 'package:insurance_company/modules/auth/viewmodel/register/register_event.dart';
import 'package:insurance_company/modules/auth/viewmodel/register/register_state.dart';

class MockRegisterBloc extends Mock implements RegisterBloc {}

void main() {
  late MockRegisterBloc mockRegisterBloc;

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<RegisterBloc>.value(
        value: mockRegisterBloc,
        child: const RegisterPage(),
      ),
    );
  }

  group('RegisterPage', () {
    testWidgets('renders all form fields correctly', (tester) async {
      when(() => mockRegisterBloc.state).thenReturn(RegisterInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(CustomTextField), findsNWidgets(5));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('CPF'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is RegisterLoading', (tester) async {
      when(() => mockRegisterBloc.state).thenReturn(RegisterLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Register'), findsNothing);
    });

    testWidgets('shows error snackbar when state is RegisterFailure', (tester) async {
      whenListen(
        mockRegisterBloc,
        Stream.fromIterable([RegisterInitial(), RegisterFailure('Error message')]),
        initialState: RegisterInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('shows success snackbar and navigates back when state is RegisterSuccess', (tester) async {
      whenListen(
        mockRegisterBloc,
        Stream.fromIterable([RegisterInitial(), RegisterSuccess()]),
        initialState: RegisterInitial(),
      );

      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<RegisterBloc>.value(
            value: mockRegisterBloc,
            child: const RegisterPage(),
          ),
          navigatorObservers: [mockObserver],
        ),
      );
      await tester.pump();

      expect(find.text('Registration successful'), findsOneWidget);
      verify(() => mockObserver.didPop(any(), any())).called(1);
    });

    testWidgets('dispatches RegisterSubmitted event when form is valid and submitted', (tester) async {
      when(() => mockRegisterBloc.state).thenReturn(RegisterInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(CustomTextField).at(0), 'João das Neves');
      await tester.enterText(find.byType(CustomTextField).at(1), '12345678901');
      await tester.enterText(find.byType(CustomTextField).at(2), 'test@example.com');
      await tester.enterText(find.byType(CustomTextField).at(3), 'password123');
      await tester.enterText(find.byType(CustomTextField).at(4), 'password123');

      await tester.tap(find.text('Register'));
      await tester.pump();

      verify(() => mockRegisterBloc.add(RegisterSubmitted(
        name: 'João das Neves',
        cpf: '12345678901',
        email: 'test@example.com',
        password: 'password123',
      ))).called(1);
    });

    testWidgets('shows error when passwords do not match', (tester) async {
      when(() => mockRegisterBloc.state).thenReturn(RegisterInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(CustomTextField).at(3), 'password123');
      await tester.enterText(find.byType(CustomTextField).at(4), 'differentpassword');

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
      verifyNever(() => mockRegisterBloc.add(any()));
    });
  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}