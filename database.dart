import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'person.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._();

  // Create a singleton instance of the PersonDatabaseProvider
  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  
  // Database field marked as 'late' for lazy initialization
  late Database _database;

  // Getter method to get the database instance asynchronously
  Future<Database> get database async {

    // If _database is already initialized, return the existing instance
    if (_database != null) return _database;
    
    // If _database is not initialized, get the instance using getDatabaseInstance()
    _database = await getDatabaseInstance();
    return _database;
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

  updatePerson(Person updatedPerson) {}

  addPersonToDatabase(Person newPerson) {}
}


