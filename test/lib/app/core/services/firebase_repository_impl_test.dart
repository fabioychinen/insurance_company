// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_company/app/core/services/firebase_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late FirebaseRepositoryImpl repository;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    repository = FirebaseRepositoryImpl(
      firebaseAuth: mockAuth,
      firestore: mockFirestore,
    );
  });

  group('Login Tests', () {
    test('should call signInWithEmailAndPassword with correct credentials', () async {
      final mockUserCredential = MockUserCredential();
      when(() => mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      await repository.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      verify(() => mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('should throw exception when login fails', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => repository.loginWithEmail(
          email: 'test@example.com',
          password: 'wrongpassword',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });

  group('Registration Tests', () {
    test('should register user and save additional data', () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      final mockDocRef = MockDocumentReference();
      final mockCollection = MockCollectionReference();

      when(() => mockAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('user123');
      
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('user123')).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any())).thenAnswer((_) async {});

      await repository.registerWithEmail(
        name: 'New User',
        cpf: '12345678901',
        email: 'new@example.com',
        password: 'password123',
      );

      verify(() => mockAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password123',
      )).called(1);

      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.doc('user123')).called(1);
      verify(() => mockDocRef.set({
        'name': 'New User',
        'cpf': '12345678901',
        'email': 'new@example.com',
        'createdAt': any(named: 'createdAt'),
      })).called(1);
    });
  });

  group('User Data Tests', () {
    test('should get current user', () {
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      final result = repository.currentUser;

      expect(result, mockUser);
      verify(() => mockAuth.currentUser).called(1);
    });

    test('should get user data from Firestore', () async {

      final mockDocRef = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();
      final mockCollection = MockCollectionReference();

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('user123')).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn({
        'name': 'Test User',
        'email': 'test@example.com',
      });

      final result = await repository.getUserData('user123');

      expect(result, mockSnapshot);
      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.doc('user123')).called(1);
      verify(() => mockDocRef.get()).called(1);
    });

    test('should update user data', () async {
      final mockDocRef = MockDocumentReference();
      final mockCollection = MockCollectionReference();
      final updateData = {'name': 'Updated Name'};

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc('user123')).thenReturn(mockDocRef);
      when(() => mockDocRef.update(updateData)).thenAnswer((_) async {});

      await repository.updateUserData('user123', updateData);

      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.doc('user123')).called(1);
      verify(() => mockDocRef.update(updateData)).called(1);
    });
  });

  group('Family Members Tests', () {
    test('should add family member', () async {
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final memberData = {'name': 'Family Member', 'relation': 'child'};

      when(() => mockFirestore.collection('users/user123/family')).thenReturn(mockCollection);
      when(() => mockCollection.add(memberData)).thenAnswer((_) async => mockDocRef);

      await repository.addFamilyMember('user123', memberData);

      verify(() => mockFirestore.collection('users/user123/family')).called(1);
      verify(() => mockCollection.add(memberData)).called(1);
    });

    test('should get family members', () async {

      final mockCollection = MockCollectionReference();
      final mockQuerySnapshot = MockQuerySnapshot();

      when(() => mockFirestore.collection('users/user123/family')).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

      final result = await repository.getFamilyMembers('user123');

      expect(result, mockQuerySnapshot);
      verify(() => mockFirestore.collection('users/user123/family')).called(1);
      verify(() => mockCollection.get()).called(1);
    });
  });

  group('Logout Test', () {
    test('should call signOut', () async {

      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockAuth.signOut()).called(1);
    });
  });
}