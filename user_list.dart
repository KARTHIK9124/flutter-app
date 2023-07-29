import 'package:flutter/material.dart';

// Define the User class to store user information
class User {
  String username;
  String email;

  User({required this.username, required this.email});

  // Convert User object to a map (JSON representation)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }

  // Create a User object from a map (JSON representation)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }
}

class UserListPage extends StatelessWidget {
  final List<User> userList;

  UserListPage({required this.userList});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for displaying the list of users using the 'userList' data.
    // You can use a ListView.builder or any other widget to display the data.

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          // Build the UI for each user in the list
          // Access user details using userList[index].username and userList[index].email
          return ListTile(
            title: Text(userList[index].username),
            subtitle: Text(userList[index].email),
          );
        },
      ),
    );
  }
}
