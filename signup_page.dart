import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'user_list.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  bool _isLoading = false;

  final LocalStorage storage = LocalStorage('login_app3');
  List<User> users = [];

  void _validateUsername(String value) {
    setState(() {
      _isUsernameValid = value.length >= 8 && value.length <= 16;
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = value.length <= 25 && value.contains('@');
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8 &&
          value.length <= 16 &&
          value.contains(RegExp(r'[0-9]')) &&
          value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
    //Future<List<Person>> person = PersonDatabaseProvider.db.getAllPersons();
    //print("database");
  }

  void _loadUsers() {
    setState(() {
      users = loadUsers();
    });
  }

  Future<void> _onRegisterButtonPressed() async {
    if (_formKey.currentState!.validate() &&
        _passwordController.text == _confirmPasswordController.text) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a delay to show the loading indicator
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Save the user information to local storage
      await storage.ready;
      storage.setItem('userName', _usernameController.text);
      storage.setItem('userEmail', _emailController.text);

      // Add the user to the list of users
      User newUser = User(
        username: _usernameController.text, // Pass the username parameter
        email: _emailController.text,
      );
      users.add(newUser);
      saveUsers(users);

      // Show the snackbar with the success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Perform any additional actions, e.g., navigate to the home page
      Navigator.pop(context); // Navigate back to the previous page (signup page)
    }
  }

  void _updateEmail(String newEmail) async {
    

    // Update the email for the current user in the list
    int currentUserIndex = users.indexWhere((user) => user.username == _usernameController.text);
    if (currentUserIndex != -1) {
      users[currentUserIndex].email = newEmail;
      saveUsers(users);
    }

  }

  void _deleteUserData() async {
    

    // Delete the current user from the list
    users.removeWhere((user) => user.username == _usernameController.text);
    saveUsers(users);

   
  }

  void saveUsers(List<User> users) async {
    final userList = users.map((user) => user.toJson()).toList();
    await storage.ready;
    storage.setItem('users', userList);
  }

  List<User> loadUsers() {
    final userList = storage.getItem('users');
    if (userList != null) {
      return (userList as List).map((userJson) => User.fromJson(userJson)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (!_isUsernameValid) {
                        return 'Username must be between 8 and 16 characters';
                      }
                      return null;
                    },
                    onChanged: _validateUsername,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email ID'),
                    validator: (value) {
                      if (!_isEmailValid) {
                        return 'Please enter a valid email (max 25 characters)';
                      }
                      return null;
                    },
                    onChanged: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (!_isPasswordValid) {
                        return 'Password must be between 8 and 16 characters, and contain 1 number and 1 special character';
                      }
                      return null;
                    },
                    onChanged: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (_passwordController.text != value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onRegisterButtonPressed,
                    child: _isLoading
                        ? CircularProgressIndicator() // Show loading indicator when registering
                        : const Text('Register'),
                    // Disable the Register button until all requirements are met or during loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isUsernameValid && _isEmailValid && _isPasswordValid
                          ? null
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Call the function to update email
                      if (_formKey.currentState!.validate()) {
                        _updateEmail(_emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email updated successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text('Update Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Call the function to delete user data
                      _deleteUserData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User data deleted successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text('Delete User Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}