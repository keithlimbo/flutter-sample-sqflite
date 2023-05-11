import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_sqflite/db/db_manager.dart';

import 'model/dog_model.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  await DBManager().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dog? dog;

  @override
  void initState() {
    super.initState();
    dog = const Dog(id: 2, name: "Chu Chu", age: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  int? res;
                  if (dog != null) {
                    res = await DBManager().insertDog(dog!);
                  }
                  print(res ?? "null");
                },
                child: Text("Submit Dog")),
            ElevatedButton(
                onPressed: () async {
                  List? res;
                  if (dog != null) {
                    res = await DBManager().getDogs();
                  }
                  print(res ?? "null");
                },
                child: Text("Get Dog")),
            ElevatedButton(
                onPressed: () async {
                  int? res;
                  Dog updateDog = Dog(id: 1, name: "Pot-pot", age: 1);
                  if (dog != null) {
                    res = await DBManager().updateDog(updateDog);
                  }
                  print(res ?? "null");
                },
                child: Text("Update Dog")),
            ElevatedButton(
                onPressed: () async {
                  int? res;
                  if (dog != null) {
                    res = await DBManager().deleteDog(2);
                  }
                  print(res ?? "null");
                },
                child: Text("Delete Dog")),
          ],
        ),
      ),
    );
  }
}
