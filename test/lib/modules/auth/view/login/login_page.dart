import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:insurance_company/modules/auth/view/login/login_page.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_bloc.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_event.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_state.dart';
import 'package:insurance_company/shared/themes/app_theme.dart';
import 'package:insurance_company/app/core/constants/app_strings.dart';

class MockLoginBloc extends Mock implements LoginBloc {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockObserver = MockNavigatorObserver();
    
    when(() => mockLoginBloc.state).thenReturn(LoginInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppColors.appTheme,
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: const LoginPage(),
      ),
      navigatorObservers: [mockObserver],
    );
  }

  group('LoginPage', () {
    testWidgets('should render initial widgets correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(AppStrings.appTitle), findsOneWidget);
      expect(find.text(AppStrings.welcome), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text(AppStrings.loginButton), findsOneWidget);
    });

    testWidgets('should show loading when state is LoginLoading', (tester) async {
      when(() => mockLoginBloc.state).thenReturn(LoginLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error snackbar when state is LoginFailure', (tester) async {
      final states = Stream.fromIterable([
        LoginInitial(),
        LoginFailure('Erro de login', error: ''),
      ]);
      
      whenListen(mockLoginBloc, states, initialState: LoginInitial());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Erro de login'), findsOneWidget);
    });

    testWidgets('should call LoginSubmitted with correct data when FAB is pressed', (tester) async {
      const testCpf = '12345678901';
      const testPassword = 'senha123';

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).at(0), testCpf);
      await tester.enterText(find.byType(TextField).at(1), testPassword);
      await tester.tap(find.byKey(const Key('login_fab')));

      verify(() => mockLoginBloc.add(LoginSubmitted(
        cpf: testCpf,
        password: testPassword,
      ))).called(1);
    });

    testWidgets('should show validation message when fields are empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byKey(const Key('login_fab')));
      await tester.pump();

      expect(find.text(AppStrings.loginFieldsRequired), findsOneWidget);
      verifyNever(() => mockLoginBloc.add(any()));
    });

    testWidgets('should navigate to RegisterPage when register tab is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text(AppStrings.loginRegister));
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any()));
    });
  });
}