class MyUser {
  final String id;
  final String username;
  final String email;

  MyUser({
    required this.id,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  static MyUser fromMap(Map<String, dynamic> map) {
    return MyUser(
      id: map['id'],
      username: map['username'],
      email: map['email'],
    );
  }
}
