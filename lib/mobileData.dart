
import 'dart:io';

import 'package:database_pratiecs/database.dart';
import 'package:database_pratiecs/loginModel.dart';
import 'package:database_pratiecs/webDataBase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



// class MoblieScreen extends StatelessWidget {
//   const MoblieScreen({super.key});
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
//       home: const MoblieScreenPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class MoblieScreenPage extends StatefulWidget {
  const MoblieScreenPage({super.key, required this.title});



  final String title;

  @override
  State<MoblieScreenPage> createState() => _MoblieScreenPageState();
}

class _MoblieScreenPageState extends State<MoblieScreenPage> {
  int _counter = 0;

  void incrementCounter() {
    setState(() {});
  }

  TextEditingController controller = TextEditingController();
  bool isOperationInProgress = false;
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MoblieScreenPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), helperText: "Enter name"),
              ),
              const Text(
                'You have pushed the button this many times:',
              ),
              ElevatedButton(
                  onPressed: () async {
                    list = await DataBaseHelper.helper.readDb();
                    setState(() {});
                  },
                  child: Text("Read")),
              Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${list[index]['name']}"),
                            InkWell(
                              onLongPress: () async {
                                print("object");
                                DataBaseHelper.helper.deleteDb(list[index]['id']);
                                list = await DataBaseHelper.helper.readDb();
                                setState(() {});
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: list.length,
                  ))
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            // Set the flag to indicate that the operation is in progress
            isOperationInProgress = true;
          });
          LoginModel model = LoginModel(name: controller.text);
          DataBaseHelper.helper.insertDb(model: model);
          setState(() {
            // Reset the flag when the operation completes
            isOperationInProgress = false;
          });
        },
        tooltip: 'Increment',
        // Use the isOperationInProgress flag to dynamically set the icon
        child: isOperationInProgress
            ? CircularProgressIndicator()
            : Icon(Icons.add),
      ),
      // floatingActionButton: FloatingActionButton(
      //
      //   onPressed: () async {
      //     print("object");
      //     LoginModel model=LoginModel(name: controller.text);
      //     DataBaseHelper.helper.insertDb(model: model);
      //     });
      //
      //     // list=await DataBaseHelper.helper.readDb();
      //     setState(() {
      //
      //     });
      //   },
      //   tooltip: 'Increment',
      //   child:  ?Icon(Icons.add):Icon(Icons.check_sharp),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}