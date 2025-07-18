import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(const HomeState(isLoading: false)) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final userName = "Usuário Exemplo";
      final family = <String>[];
      final contracted = <String>[];

      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
        isLoading: false,
        userName: userName,
        familyMembers: family,
        contractedInsurances: contracted,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}