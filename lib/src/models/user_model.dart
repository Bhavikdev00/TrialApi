class User {
  String id;
  String name;
  String email;
  String password;
  String phoneNumber;
  String role;
  DateTime createdAt;
  String  profile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
    required this.createdAt,
    required this.profile,
  });

  // Factory method to create a User instance from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      createdAt: DateTime.parse(map['createdAt']),
      profile: map['profile'],
    );
  }

  // Method to convert User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'profile': profile,
    };
  }
}
