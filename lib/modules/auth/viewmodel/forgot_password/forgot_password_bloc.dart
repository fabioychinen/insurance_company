import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/services/firebase_repository_impl.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final FirebaseRepositoryImpl repository;

  ForgotPasswordBloc(this.repository) : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      await repository.sendPasswordResetEmail(event.email);
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), success: false));
    }
  }
}