import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_company/app/core/services/firebase_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_bloc.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_event.dart';
import 'package:insurance_company/modules/auth/viewmodel/login/login_state.dart';

class MockFirebaseRepository extends Mock implements FirebaseRepositoryImpl {}

void main() {
  late LoginBloc loginBloc;
  late MockFirebaseRepository mockRepository;

  setUp(() {
    mockRepository = MockFirebaseRepository();
    loginBloc = LoginBloc(mockRepository as FirebaseRepositoryImpl);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    const testCpf = '12345678901';
    const testPassword = 'senha123';
    const testEmail = 'test@example.com';

    test('initial state should be LoginInitial', () {
      expect(loginBloc.state, isA<LoginInitial>());
    });

    group('LoginSubmitted', () {
      test('should emit [Loading, Success] when login is successful', () async {
        when(() => mockRepository.getEmailByCpf(testCpf))
            .thenAnswer((_) async => testEmail);
        when(() => mockRepository.loginWithEmail(email: testEmail, password: testPassword))
            .thenAnswer((_) async => MockUserCredential());

        loginBloc.add(const LoginSubmitted(cpf: testCpf, password: testPassword));

        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            isA<LoginLoading>(),
            isA<LoginSuccess>(),
          ]),
        );
      });

      test('should emit [Loading, Failure] when CPF is not registered', () async {
        when(() => mockRepository.getEmailByCpf(testCpf))
            .thenAnswer((_) async => null);

        loginBloc.add(const LoginSubmitted(cpf: testCpf, password: testPassword));

        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            isA<LoginLoading>(),
            isA<LoginFailure>(),
          ]),
        );
        verifyNever(() => mockRepository.loginWithEmail(email: any(),password:  any()));
      });

      test('should emit [Loading, Failure] when login fails', () async {
        when(() => mockRepository.getEmailByCpf(testCpf))
            .thenAnswer((_) async => testEmail);
        when(() => mockRepository.loginWithEmail(email: testEmail, password: testPassword))
            .thenThrow(Exception('Login failed'));

        loginBloc.add(const LoginSubmitted(cpf: testCpf, password: testPassword));

        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            isA<LoginLoading>(),
            isA<LoginFailure>(),
          ]),
        );
      });
    });
  });
}

class MockUserCredential extends Mock implements UserCredential {}