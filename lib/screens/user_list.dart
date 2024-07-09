import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab3/controller/controller.dart';
import 'package:solulab3/screens/add_user.dart';
import 'package:solulab3/screens/user_details.dart';

class UserList extends StatelessWidget {
  
  UserList({super.key});

  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User List'),
        actions: [
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
            : _userController.users.isEmpty
                ? const Center(
                    child: Text('No users found'),
                  )
                : ListView.builder(
                    itemCount: _userController.users.length,
                    itemBuilder: (context, index) {
                      final user = _userController.users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar ?? ''),
                        ),
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(user.email),
                        onTap: () {
                          _userController.getUserDetails(user.id!);
                          Get.to(() => UserDetails(userId: user.id!));
                        },
                        trailing: IconButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(context, user.id!),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddUser());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Get.back();

                try {
                  await _userController.deleteUser(userId);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'User Deleted Successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (error) {
                  Get.back();
                  Get.snackbar(
                    'Error',
                    'Failed to delete user',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}