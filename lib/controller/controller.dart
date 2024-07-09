import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solulab3/api/api_client.dart';
import 'package:solulab3/model/models.dart';
import 'package:solulab3/screens/user_list.dart';
import 'package:solulab3/screens/login_screen.dart';

class UserController extends GetxController {
  final ReqresApiService _apiService = ReqresApiService();
  final RxList<User> _users = <User>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<User?> selectedUser = Rx<User?>(null);

  List<User> get users => _users.toList();
  User? get currentUser => selectedUser.value;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    fetchUsers();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    if (token != null) {
      Get.off(() => UserList());
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      _users.value = await _apiService.getUsers(1);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch users: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      final response =
          await _apiService.registerUser(email: email, password: password);
      if (response != null && response.statusCode == 200) {
        final String? token = response.data['token'];
        if (token != null) {
          final SharedPreferences prefs = await _prefs;
          await prefs.setString('token', token);
        }
        
        Get.snackbar(
          'Success',
          'Registration successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.off(() => UserList());
      } else {
        Get.snackbar(
          'Error',
          'Registration failed!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    if (GetUtils.isEmail(email) && password.isNotEmpty) {
      try {
        isLoading.value = true;
        final response = await _apiService.loginUser(email, password);
        if (response != null && response.statusCode == 200) {
          final String? token = response.data['token'];
          if (token != null) {
            final SharedPreferences prefs = await _prefs;
            await prefs.setString('token', token);
          }

          Get.snackbar(
            'Success',
            'Login successful!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.off(() => UserList());
        } else {
          Get.snackbar(
            'Error',
            'Invalid email or password!',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    } else if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addUser(UserCreation user) async {
    try {
      isLoading.value = true;
      final newUser = await _apiService.createUser(user);
      if (newUser != null) {
        _users.add(newUser);
        Get.snackbar(
          'Success',
          'User added successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add user',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add user: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserDetails(int userId) async {
    try {
      isLoading.value = true;
      final fetchedUser = await _apiService.getUser(userId);
      if (fetchedUser != null) {
        selectedUser.value = fetchedUser;
      } else {
        Get.snackbar(
          'Error',
          'Failed to get user details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get user details: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      if (kDebugMode) {
        print('Updating user: ${user.toJson()}');
      }
      isLoading.value = true;
      final updatedUser = await _apiService.updateUser(user.id!, user);
      if (kDebugMode) {
        print('Updated user received: ${updatedUser?.toJson()}');
      }
      if (updatedUser != null) {
        final index = _users.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) {
          _users[index] = updatedUser;
        }

        Get.back();

        Get.snackbar(
          'Success',
          'User updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update user',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      isLoading.value = true;
      final isDeleted = await _apiService.deleteUser(userId);
      if (isDeleted) {
        _users.removeWhere((user) => user.id == userId);
        Get.snackbar(
          'Success',
          'User deleted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete user',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete user: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('token');
    Get.offAll(() => LoginScreen());
  }
}