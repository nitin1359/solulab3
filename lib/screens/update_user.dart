import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab3/controller/controller.dart';
import 'package:solulab3/model/models.dart';

class UpdateUser extends StatelessWidget {
  final int userId;

  UpdateUser({super.key, required this.userId});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    final User? user =
        _userController.users.firstWhereOrNull((u) => u.id == userId);

    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedUser = User(
                      id: userId,
                      email: _emailController.text.trim(),
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                    );

                    await _userController.updateUser(updatedUser);

                    if (!_userController.isLoading.value) {
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'User Updated Successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                child: Obx(() => _userController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Update User')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}