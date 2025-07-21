import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/app/core/repositories/firebase_repository.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_event.dart';
import 'package:insurance_company/modules/auth/viewmodel/forgot_password/forgot_password_state.dart';


class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final FirebaseRepository firebaseRepository;

  ForgotPasswordBloc(this.firebaseRepository) : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      await firebaseRepository.sendPasswordResetEmail(event.email);
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}