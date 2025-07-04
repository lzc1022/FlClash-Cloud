class UserModel {
  String? name;
  String? email;
  String? password;
  String? token;
  String? auth_data;
  int? is_admin = 0;

  /// Creates a new UserModel.
  UserModel(
      {this.name,
      this.email,
      this.password,
      this.token,
      this.auth_data,
      this.is_admin});

  /// Converts this UserModel to a Map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'token': token,
      'auth_data': auth_data,
      'is_admin': is_admin
    };
  }

  /// Creates a new UserModel from a Map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        token: json['token'],
        auth_data: json['auth_data'],
        is_admin: json['is_admin']);
  }
}
