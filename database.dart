import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'person.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._();

  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "users.db");
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Person ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "name TEXT,"
            "city TEXT"
            ")");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print("Upgrading database from version $oldVersion to $newVersion");
        if (oldVersion == 1 && newVersion == 2) {
          print("Executing database upgrade logic...");
          await db.execute("ALTER TABLE Person "
              "ADD COLUMN first_name TEXT, "
              "ADD COLUMN last_name TEXT, "
              "ADD COLUMN phone_number TEXT, "
              "ADD COLUMN email TEXT, "
              "ADD COLUMN address TEXT, "
              "ADD COLUMN postal_code TEXT, "
              "ADD COLUMN active INTEGER");
          print("Database upgrade complete!");
        }
      },
    );
  }

  Future<int> addPersonToDatabase(Person person) async {
    final db = await database;
    var raw = await db!.insert(
      "Person",
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<int> updatePerson(Person person) async {
    final db = await database;
    var response = await db!.update("Person", person.toMap(),
        where: "id = ?", whereArgs: [person.id]);
    return response;
  }

  Future<Person?> getPersonWithId(int id) async {
    final db = await database;
    var response = await db!.query("Person", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    var response = await db!.query("Person");
    List<Person> list = response.map((d) => Person.fromMap(d)).toList();
    return list;
  }

  Future<int> deletePersonWithId(int id) async {
    final db = await database;
    return db!.delete("Person", where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteAllPersons() async {
    final db = await database;
    await db!.delete("Person");
  }
}
