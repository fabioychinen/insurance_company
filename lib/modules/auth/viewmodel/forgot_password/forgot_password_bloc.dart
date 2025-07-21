import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/repositories/firebase_repository.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final FirebaseRepository repository;

  ForgotPasswordBloc(this.repository) : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordState(isLoading: true));
    try {
      await repository.sendPasswordResetEmail(event.email);
      emit(const ForgotPasswordState(isLoading: false, success: true));
    } catch (e) {
      emit(ForgotPasswordState(isLoading: false, error: e.toString()));
    }
  }
}