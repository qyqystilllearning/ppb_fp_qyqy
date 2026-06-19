
  import 'package:flutter/material.dart';

  void main() => runApp(MyApp());

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp( // the whole screen
        home: Scaffold( // the appbar and body
          appBar: AppBar( // the appbar (kind of like the header)
            title: Text("Rizqys first app lohya"),
            centerTitle: true,
            backgroundColor: Colors.amber[200],
          ),
          body: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  width: 100,
                  height: 100,
                  child: Text('Container atas'),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  width: 150,
                  height: 150,
                  child: Text('Container bawah'),
                ),
              ],
            ),
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              shape: CircleBorder(),
              padding: EdgeInsets.all(20.0),
            ),
          ),
        ),
      );
    }
  }