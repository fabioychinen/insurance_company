import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IFirebaseRepository {
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential> registerWithEmail({
    required String name,
    required String cpf,
    required String email,
    required String password,
  });

  Future<void> logout();

  User? get currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid);

  Future<void> updateUserData(String uid, Map<String, dynamic> data);

  Future<void> addFamilyMember(String uid, Map<String, dynamic> member);

  Future<QuerySnapshot<Map<String, dynamic>>> getFamilyMembers(String uid);
}