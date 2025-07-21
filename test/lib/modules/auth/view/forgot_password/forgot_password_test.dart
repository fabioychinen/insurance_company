import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:insurance_company/modules/auth/view/forgot_password/forgot_password_page.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_bloc.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_event.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_state.dart';

class MockForgotPasswordBloc extends Mock implements ForgotPasswordBloc {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}

void main() {
  late ForgotPasswordBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordEvent());
    registerFallbackValue(FakeForgotPasswordState());
  });

  setUp(() {
    bloc = MockForgotPasswordBloc();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ForgotPasswordBloc>(
        create: (_) => bloc,
        child: const ForgotPasswordPage(),
      ),
    );
  }

  testWidgets('renders ForgotPasswordPage UI elements', (tester) async {
    when(() => bloc.state).thenReturn(const ForgotPasswordState());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('shows SnackBar if email field is empty on submit', (tester) async {
    when(() => bloc.state).thenReturn(const ForgotPasswordState());

    await tester.pumpWidget(buildTestableWidget());

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('dispatches ForgotPasswordSubmitted when email is valid', (tester) async {
    when(() => bloc.state).thenReturn(const ForgotPasswordState());
    when(() => bloc.add(any())).thenReturn(null);

    await tester.pumpWidget(buildTestableWidget());

    final emailField = find.byType(TextField);
    await tester.enterText(emailField, 'test@example.com');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => bloc.add(any())).called(1);
  });

  testWidgets('shows success SnackBar and pops on success state', (tester) async {
    whenListen(
      bloc,
      Stream.fromIterable([
        const ForgotPasswordState(isLoading: true),
        const ForgotPasswordState(isLoading: false, success: true),
      ]),
      initialState: const ForgotPasswordState(),
    );
    when(() => bloc.state).thenReturn(const ForgotPasswordState());

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Recovery email sent successfully!'), findsOneWidget);
  });

  testWidgets('shows error SnackBar when state has error', (tester) async {
    whenListen(
      bloc,
      Stream.fromIterable([
        const ForgotPasswordState(isLoading: false, error: 'Unexpected error'),
      ]),
      initialState: const ForgotPasswordState(),
    );
    when(() => bloc.state).thenReturn(const ForgotPasswordState());

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Failed to send email: Unexpected error'), findsOneWidget);
  });
}