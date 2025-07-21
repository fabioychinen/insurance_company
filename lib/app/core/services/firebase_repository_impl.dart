import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
    
  FirebaseRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> registerWithEmail({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final uid = userCredential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'cpf': cpf,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return userCredential;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<String?> getEmailByCpf(String cpf) async {
    final result = await _firestore
        .collection('users')
        .where('cpf', isEqualTo: cpf)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      return result.docs.first.data()['email'] as String?;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  @override
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  @override
  Future<void> addFamilyMember(String uid, Map<String, dynamic> member) async {
    await _firestore.collection('users').doc(uid).collection('family').add(member);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getFamilyMembers(String uid) async {
    return await _firestore.collection('users').doc(uid).collection('family').get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não logado');
    return await _firestore.collection('users').doc(uid).get();
  }
}