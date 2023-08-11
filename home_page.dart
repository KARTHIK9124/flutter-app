import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'todo_list.dart';
import 'user_list.dart';
import 'person_list_page.dart'; 

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> users; // Pass the list of users to HomePage

  HomePage({required this.users});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  final LocalStorage storage = LocalStorage('login_app3'); // Create an instance of LocalStorage

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    await storage.ready;
    setState(() {
      _userName = storage.getItem('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome To The HomePage',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Hello, $_userName!', // Display the user's name here
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Signup'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
            ),
            ListTile(
              title: const Text('ToDo List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TodoListPage(title: 'ToDo Manager'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('User List'), 
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(
                      userList: widget.users.map((userJson) => User.fromJson(userJson)).toList(),
                    ),
                  ),
                );
              },
            ),
            // New entry for Person List
            ListTile(
              title: const Text('Person List'), 
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonListPage(), // Navigate to PersonListPage
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
