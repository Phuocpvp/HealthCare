class User {
  final String username;
  final String email;
  final String password;
  final String gender;
  final String birthOfDate;
  User(
      {required this.username,
      required this.email,
      required this.password,
      required this.gender,
      required this.birthOfDate});

  // Chuyển đổi từ object thành JSON để gửi tới server
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "gender": gender,
      "birthOfDate": birthOfDate
    };
  }
}
