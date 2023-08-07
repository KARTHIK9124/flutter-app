import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'person.dart';
import 'package:sqflite/sqflite.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._() {
    _initDatabase();
  }

  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  Database? _database; // Make the field nullable

  Future<Database> get database async {
    // Use a getter to handle possible null database
    if (_database != null) return _database!;
    await _initDatabase(); // Initialize the database if not already done
    return _database!;
  }

  Future<void> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "person.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Person ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "city TEXT"
          ")");
    });
  }

  // Method to create or open the SQLite database
  Future<Database> getDatabaseInstance() async {
    // Get the directory where the database file will be stored
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "person.db");
    
    // Open or create the database at the specified path with version 1
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When the database is created for the first time, execute this code
          // to create the 'Person' table with columns 'id', 'name', and 'email'
          await db.execute("CREATE TABLE Person ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "name TEXT,"
              "email TEXT"
              ")");
        });
  }

  // Function to insert or update a person in the database
  Future<int> insertOrUpdatePerson(Person person) async {
    final db = await database;
    return await db.insert(
      "Person",
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to retrieve a person from the database by its id
  Future<Person?> getPersonWithId(int id) async {
    final db = await database;
    var response = await db.query("Person", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

  // Function to retrieve all persons from the database
  Future<List<Person>> getAllPersons() async {
    final db = await database;
    var response = await db.query("Person");
    List<Person> list = response.map((c) => Person.fromMap(c)).toList();
    return list;
  }

  // Function to delete a person from the database by its id
  Future<int> deletePersonWithId(int id) async {
    final db = await database;
    return db.delete("Person", where: "id = ?", whereArgs: [id]);
  }

  // Function to delete all persons from the database
  Future<void> deleteAllPersons() async {
    final db = await database;
    db.delete("Person");
  }
}


