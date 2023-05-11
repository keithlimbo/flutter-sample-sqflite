import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/dog_model.dart';

class DBManager {
  Database? database;

  Future<Database?> init() async {
    // Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  // Define a function that inserts dogs into the database
  Future<int?> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await init();
    int? res;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    if (db != null) {
      res = await db.insert(
        'dogs',
        dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return res;
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>?> getDogs() async {
    // Get a reference to the database.
    final db = await init();
    List<Map<String, dynamic>>? maps;

    // Query the table for all The Dogs.
    if (db != null) {
      maps = await db.query('dogs');
    }

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    if (maps != null) {
      return List.generate(maps.length, (i) {
        return Dog(
          id: maps?[i]['id'],
          name: maps?[i]['name'],
          age: maps?[i]['age'],
        );
      });
    } else {
      return null;
    }
  }

  Future<int?> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await init();
    int? res;
    // Update the given Dog.
    if (db != null) {
      res = await db.update(
        'dogs',
        dog.toMap(),
        // Ensure that the Dog has a matching id.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [dog.id],
      );
    }

    return res;
  }

  Future<int?> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await init();
    int? res;
    // Remove the Dog from the database.
    if (db != null) {
      res = await db.delete(
        'dogs',
        // Use a `where` clause to delete a specific dog.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }
    return res;
  }
}
