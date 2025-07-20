import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String userName;
   final String userEmail;
  final List<dynamic> familyMembers;
  final List<dynamic> contractedInsurances;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.userName = '',
    this.userEmail = '',
    this.familyMembers = const [],
    this.contractedInsurances = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    String? userName,
    String? userEmail,
    List<dynamic>? familyMembers,
    List<dynamic>? contractedInsurances,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      familyMembers: familyMembers ?? this.familyMembers,
      contractedInsurances: contractedInsurances ?? this.contractedInsurances,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [userName, familyMembers, contractedInsurances, isLoading, error];
}