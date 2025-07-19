import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/services/firebase_repository_impl.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseRepositoryImpl repository; 

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final userEmail = await repository.getEmailByCpf(event.cpf);

      if (userEmail == null) {
        emit(LoginFailure("CPF não cadastrado!", error: ''));
        return;
      }


      await repository.loginWithEmail(
        email: userEmail,
        password: event.password,
      );

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure("CPF ou senha inválidos", error: ''));
    }
  }
}