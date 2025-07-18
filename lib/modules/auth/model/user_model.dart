class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? cpf;

  UserModel({
    required this.uid,
    this.name,
    this.email,
    this.cpf,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] as String?,
      email: map['email'] as String?,
      cpf: map['cpf'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'cpf': cpf,
    };
  }
}