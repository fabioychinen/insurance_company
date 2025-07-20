import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../app/core/services/firebase_repository_impl.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseRepositoryImpl repository;

  HomeBloc(this.repository) : super(const HomeState(isLoading: false)) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = repository.currentUser;
      if (user == null) throw Exception("Usuário não autenticado!");

      final userDoc = await repository.getUserData(user.uid);
      final userData = userDoc.data();
      final userName = userData?['name'] ?? '';
      final userEmail = userData?['email'] ?? '';

      final family = <String>[];
      final contracted = <String>[];

      emit(state.copyWith(
        isLoading: false,
        userName: userName,
        userEmail: userEmail,
        familyMembers: family,
        contractedInsurances: contracted,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}