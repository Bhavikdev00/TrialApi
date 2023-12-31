class OtpModel {
  String? id; // Use String? for optional id
  String email;
  String otp;
  DateTime createdAt;

  OtpModel({
    this.id,
    required this.email,
    required this.otp,
    required this.createdAt,
  });

  // Factory method to create OtpModel instance from a Map
  factory OtpModel.fromMap(Map<String, dynamic> map) {
    return OtpModel(
      id: map['id'],
      email: map['email'],
      otp: map['otp'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Method to convert OtpModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'otp': otp,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
