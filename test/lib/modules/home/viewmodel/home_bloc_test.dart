import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/modules/home/viewmodel/home_bloc.dart';
import 'package:insurance_company/modules/home/viewmodel/home_event.dart';
import 'package:insurance_company/modules/home/viewmodel/home_state.dart';
import 'package:insurance_company/app/core/repositories/firebase_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseRepositoryImpl extends Mock implements FirebaseRepositoryImpl {}
class MockUser extends Mock implements User {}

class TestDocumentSnapshot {
  final Map<String, dynamic> _data;
  TestDocumentSnapshot(this._data);
  Map<String, dynamic> data() => _data;
}

void main() {
  late MockFirebaseRepositoryImpl mockRepository;
  late HomeBloc bloc;

  setUp(() {
    mockRepository = MockFirebaseRepositoryImpl();
  });

  test('emits loading and loaded states when user is authenticated', () async {
    final mockUser = MockUser();
    final fakeDoc = TestDocumentSnapshot({
      'name': 'Test User',
      'email': 'test@email.com',
    });

    when(() => mockRepository.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('user123');
    when(() => mockRepository.getUserData('user123')).thenAnswer((_) async => fakeDoc as DocumentSnapshot<Map<String, dynamic>>);


    bloc = HomeBloc(mockRepository);

    final states = <HomeState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(LoadHomeData());

    await Future.delayed(const Duration(milliseconds: 100));

    expect(states.length, 2);

    expect(states[0].isLoading, isTrue);
    expect(states[1].isLoading, isFalse);
    expect(states[1].userName, 'Test User');
    expect(states[1].userEmail, 'test@email.com');
    expect(states[1].familyMembers, isA<List>());
    expect(states[1].contractedInsurances, isA<List>());

    await subscription.cancel();
    await bloc.close();
  });

  test('emits error state when user is not authenticated', () async {
    when(() => mockRepository.currentUser).thenReturn(null);

    bloc = HomeBloc(mockRepository);

    final states = <HomeState>[];
    final subscription = bloc.stream.listen(states.add);

    bloc.add(LoadHomeData());

    await Future.delayed(const Duration(milliseconds: 100));

    expect(states.length, 2);
    expect(states[1].isLoading, isFalse);
    expect(states[1].error, contains('Usuário não autenticado'));

    await subscription.cancel();
    await bloc.close();
  });
}