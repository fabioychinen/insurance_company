import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/app/core/services/firebase_repository_impl.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseRepositoryImpl repository;

  RegisterBloc(this.repository) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      await repository.registerWithEmail(
        name: event.name,
        cpf: event.cpf,
        email: event.email,
        password: event.password,
      );
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}