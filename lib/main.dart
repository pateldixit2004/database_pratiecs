// import 'dart:io';
//
// import 'package:database_pratiecs/database.dart';
// import 'package:database_pratiecs/loginModel.dart';
// import 'package:database_pratiecs/webDataBase.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// void main() {
//   runApp(const MyApp());
//
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void incrementCounter() {
//     setState(() {});
//   }
//
//   TextEditingController controller = TextEditingController();
//   bool isOperationInProgress = false;
//   List list = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child:Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(), helperText: "Enter name"),
//             ),
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   list = await DataBaseHelper.helper.readDb();
//                   setState(() {});
//                 },
//                 child: Text("Read")),
//             Expanded(
//                 child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("${list[index]['name']}"),
//                       InkWell(
//                         onLongPress: () async {
//                           print("object");
//                           DataBaseHelper.helper.deleteDb(list[index]['id']);
//                           list = await DataBaseHelper.helper.readDb();
//                           setState(() {});
//                         },
//                         child: Text(
//                           "Delete",
//                           style: TextStyle(color: Colors.deepOrange),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               itemCount: list.length,
//             ))
//           ],
//         )
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           setState(() {
//             // Set the flag to indicate that the operation is in progress
//             isOperationInProgress = true;
//           });
//           LoginModel model = LoginModel(name: controller.text);
//           DataBaseHelper.helper.insertDb(model: model);
//           setState(() {
//             // Reset the flag when the operation completes
//             isOperationInProgress = false;
//           });
//         },
//         tooltip: 'Increment',
//         // Use the isOperationInProgress flag to dynamically set the icon
//         child: isOperationInProgress
//             ? CircularProgressIndicator()
//             : Icon(Icons.add),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //
//       //   onPressed: () async {
//       //     print("object");
//       //     LoginModel model=LoginModel(name: controller.text);
//       //     DataBaseHelper.helper.insertDb(model: model);
//       //     });
//       //
//       //     // list=await DataBaseHelper.helper.readDb();
//       //     setState(() {
//       //
//       //     });
//       //   },
//       //   tooltip: 'Increment',
//       //   child:  ?Icon(Icons.add):Icon(Icons.check_sharp),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
import 'package:database_pratiecs/mobileData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqlite_api.dart';

class UserModel {
  final String name;

  UserModel({required this.name});
}

class DatabaseHelper {
  late Database database;

  Future<void> initDatabase() async {
    database = await databaseFactoryFfiWeb.openDatabase('my_web_web.db');

    // Create the user table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
  }

  Future<void> insertUser(UserModel user) async {
    // Insert user into the users table
    await database.insert('users', {'name': user.name},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<UserModel>> getUsers() async {
    // Query all users from the users table
    final List<Map<String, dynamic>> maps = await database.query('users');

    // Convert the List<Map<String, dynamic>> to a List<UserModel>
    return List.generate(maps.length, (i) {
      return UserModel(name: maps[i]['name']);
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 if(kIsWeb)
   {
     final dbHelper = DatabaseHelper();
     await dbHelper.initDatabase();

     runApp(MyApp(dbHelper: dbHelper));
   }
 else
   {
     runApp(
      MaterialApp(
        home: MoblieScreenPage(title: 'Text',)
      )
     );
   }
}

class MyApp extends StatefulWidget {
  final DatabaseHelper dbHelper;

  MyApp({required this.dbHelper});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = widget.dbHelper.getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SQLite Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Name"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await widget.dbHelper
                      .insertUser(UserModel(name: controller.text));
                  setState(() {});
                },
                child: Text('Insert User'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _usersFuture = widget.dbHelper.getUsers();
                  });
                },
                child: Text('Get Users'),
              ),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  // future: widget.dbHelper.getUsers(),
                  future:  _usersFuture,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final users = snapshot.data!;
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            title: Text(user.name),
                            subtitle: Text('ID: ${index + 1}'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

