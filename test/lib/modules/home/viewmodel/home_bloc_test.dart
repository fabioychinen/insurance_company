// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:insurance_company/modules/home/viewmodel/home_bloc.dart';
import 'package:insurance_company/modules/home/viewmodel/home_event.dart';
import 'package:insurance_company/modules/home/viewmodel/home_state.dart';
import 'package:insurance_company/app/core/repositories/firebase_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseRepositoryImpl extends Mock implements FirebaseRepositoryImpl {}
class MockUser extends Mock implements User {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseRepositoryImpl mockRepository;
  late HomeBloc bloc;

  setUp(() {
    mockRepository = MockFirebaseRepositoryImpl();

    registerFallbackValue(FakeDocumentSnapshot());
  });

  test('emits loading and loaded states when user is authenticated', () async {
    final mockUser = MockUser();
    final mockDocSnapshot = MockDocumentSnapshot();

    when(() => mockRepository.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('user123');
    when(() => mockRepository.getUserData('user123')).thenAnswer((_) async => mockDocSnapshot);
    when(() => mockDocSnapshot.data()).thenReturn({
      'name': 'Test User',
      'email': 'test@email.com',
    });

    bloc = HomeBloc(mockRepository);

    await expectLater(
      bloc.stream,
      emitsInOrder([

        predicate<HomeState>((state) => state.isLoading == true),

        predicate<HomeState>((state) =>
            state.isLoading == false &&
            state.userName == 'Test User' &&
            state.userEmail == 'test@email.com'),
      ]),
    );

    bloc.add(LoadHomeData());

    await bloc.close();
  });
}