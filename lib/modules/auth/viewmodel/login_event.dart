import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginSubmitted extends LoginEvent {
  final String cpf;
  final String password;

  const LoginSubmitted({required this.cpf, required this.password});

  @override
  List<Object> get props => [cpf, password];
}