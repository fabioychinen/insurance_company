// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_company/modules/auth/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late AuthRepository authRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('AuthRepository', () {
    test('login calls FirebaseAuth.signInWithEmailAndPassword', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@email.com',
        password: '1234',
      )).thenAnswer((_) async => MockUserCredential());

      await authRepository.login('test@email.com', '1234');

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@email.com',
        password: '1234',
      )).called(1);
    });

    test('register calls createUserWithEmailAndPassword and sets user data', () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      final mockCollection = MockCollectionReference();
      final mockDoc = MockDocumentReference();

      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@email.com',
        password: '1234',
      )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('abc123');

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('abc123')).thenReturn(mockDoc);
      when(() => mockDoc.set(any())).thenAnswer((_) async {});

      await authRepository.register(
        name: 'John Doe',
        cpf: '12345678901',
        email: 'test@email.com',
        password: '1234',
      );

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@email.com',
        password: '1234',
      )).called(1);

      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.doc('abc123')).called(1);
      verify(() => mockDoc.set(any())).called(1);
    });

    test('logout calls FirebaseAuth.signOut', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await authRepository.logout();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });
}