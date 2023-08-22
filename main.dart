import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'home_page.dart';


void main() {
  runApp(MyApp());
   {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}
}

class MyApp extends StatelessWidget {
  final LocalStorage storage = LocalStorage('login_app3');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage(users: snapshot.data!);
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    await storage.ready;
    final userList = storage.getItem('users');
    if (userList != null) {
      return List<Map<String, dynamic>>.from(userList);
    }

    return [];
  }
}
