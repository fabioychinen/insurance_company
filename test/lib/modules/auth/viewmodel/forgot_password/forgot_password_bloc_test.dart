import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_bloc.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_event.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_state.dart';
import 'package:insurance_company/app/core/repositories/firebase_repository.dart';

class MockFirebaseRepository extends Mock implements FirebaseRepository {}

void main() {
  late ForgotPasswordBloc bloc;
  late MockFirebaseRepository mockRepository;

  setUp(() {
    mockRepository = MockFirebaseRepository();
    bloc = ForgotPasswordBloc(mockRepository);
  });

  test('initial state is ForgotPasswordState with default values', () {
    expect(bloc.state, const ForgotPasswordState());
  });

  test('emits loading and success when email reset succeeds', () async {
    when(() => mockRepository.sendPasswordResetEmail(any()))
        .thenAnswer((_) async => Future.value());

    bloc.add(ForgotPasswordSubmitted(email: 'test@example.com'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const ForgotPasswordState(isLoading: true),
        const ForgotPasswordState(isLoading: false, success: true),
      ]),
    );
  });

  test('emits loading and error when email reset fails', () async {
    when(() => mockRepository.sendPasswordResetEmail(any()))
        .thenThrow(Exception('Failed to send email'));

    bloc.add(ForgotPasswordSubmitted(email: 'test@example.com'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const ForgotPasswordState(isLoading: true),
        predicate<ForgotPasswordState>((state) =>
            state.isLoading == false && state.error != null),
      ]),
    );
  });
}