class AuthModel {
  final String? id;
  final String? email;
  final String? password;
  final String? avatar;
  final String? fullName;
  final String? phoneNumber;

  AuthModel(
      {this.id,
      this.email,
      this.password,
      this.avatar,
      this.fullName,
      this.phoneNumber});
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'fullName': fullName,
      'password': password,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
    };
  }

  static AuthModel fromJson(Map<String, dynamic> json) {
    return AuthModel(
        id: json['_id'],
        email: json['email'],
        password: json['password'],
        avatar: json['avatar'],
        fullName: json['fullName'],
        phoneNumber: json['phoneNumber']);
  }
}
