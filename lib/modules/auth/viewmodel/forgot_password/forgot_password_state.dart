import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool success;

  const ForgotPasswordState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, success];
}