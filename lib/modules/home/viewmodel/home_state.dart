import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String? userName;
  final List<dynamic>? familyMembers;
  final List<dynamic>? contractedInsurances;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.userName,
    this.familyMembers,
    this.contractedInsurances,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    String? userName,
    List<dynamic>? familyMembers,
    List<dynamic>? contractedInsurances,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      familyMembers: familyMembers ?? this.familyMembers,
      contractedInsurances: contractedInsurances ?? this.contractedInsurances,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [userName, familyMembers, contractedInsurances, isLoading, error];
}