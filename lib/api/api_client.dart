// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solulab3/model/models.dart';

class ReqresApiService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Dio> _getDioInstance() async {
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');

    return Dio(
      BaseOptions(
        baseUrl: 'https://reqres.in/api/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  Future<Response?> registerUser(
      {String? email, String? password, RegistrationRequest? registrationRequest}) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.post(
        'register',
        data: registrationRequest?.toJson() ?? {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  Future<Response?> loginUser(String email, String password) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.post(
        'login',
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<List<User>> getUsers(int page) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.get('users?page=$page');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Get Users Error: $e');
      return [];
    }
  }

  Future<User?> getUser(int userId) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.get('users/$userId');
      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      } else {
        print('Get User Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get User Error: $e');
      return null;
    }
  }

  Future<User?> createUser(UserCreation user) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.post('users', data: user.toJson());
      if (response.statusCode == 201) {
        print('Created User Response: ${response.data}');
        return User.fromJson(response.data);
      } else {
        print('Create User Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Create User Error: $e');
      return null;
    }
  }

  Future<AddNewUserModel?> createNewUser(UserCreation user) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.post('users', data: user.toJson());
      if (response.statusCode == 201) {
        print('Created User Response: ${response.data}');
        return AddNewUserModel.fromJson(response.data);
      } else {
        print('Create User Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Create User Error: $e');
      return null;
    }
  }

  Future<User?> updateUser(int userId, User user) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.put(
        'users/$userId',
        data: user.toJson(),
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        print('Update User Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Update User Error: $e');
      return null;
    }
  }

  Future<bool> deleteUser(int userId) async {
    try {
      final dio = await _getDioInstance();
      final response = await dio.delete('users/$userId');
      return response.statusCode == 204;
    } catch (e) {
      print('Delete User Error: $e');
      return false;
    }
  }
}