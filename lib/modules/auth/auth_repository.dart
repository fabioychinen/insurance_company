import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.firebaseAuth, required this.firestore});

  Future<void> login(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await firestore.collection('users').doc(userCredential.user!.uid).set({
      'name': name,
      'cpf': cpf,
      'email': email,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}