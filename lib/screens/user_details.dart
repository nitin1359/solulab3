import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab3/controller/controller.dart';
import 'package:solulab3/screens/update_user.dart';

class UserDetails extends StatelessWidget {
  final int userId;
  UserDetails({super.key, required this.userId});

  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Details'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => UpdateUser(userId: userId)),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _userController.logoutUser();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(
        () => _userController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _userController.currentUser != null
                ? _buildUserDetails(_userController.currentUser!)
                : const Center(child: Text('User not found')),
      ),
    );
  }

  Widget _buildUserDetails(user) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(user.avatar ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.email,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}