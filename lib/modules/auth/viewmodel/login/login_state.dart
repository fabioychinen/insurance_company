import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(String s, {required this.error});

  @override
  List<Object?> get props => [error];
}