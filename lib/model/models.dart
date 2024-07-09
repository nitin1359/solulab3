class RegistrationRequest {
  final String email;
  final String password;

  RegistrationRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class UserCreation {
  final String name;
  final String job;

  UserCreation({
    required this.name,
    required this.job,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job': job,
    };
  }
}

class User {
  final int? id;
  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final String? avatar;

  User({
    this.id,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      
    };
  }
}

class AddNewUserModel {
  final String? id;
  final String? name;
  final String? job;
  final String? createdAt;

  AddNewUserModel({
    this.id,
    this.name,
    this.job,
    this.createdAt,
  });

  factory AddNewUserModel.fromJson(Map<String, dynamic> json) {
    return AddNewUserModel(
      id: json['id'].toString(),
      name: json['name'],
      job: json['job'],
      createdAt: json['createdAt'],
    );
  }
}