
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
          body: Center( // the body (the main content)
            child: Text(
              'perihal cincin, kucari waktu',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton( // the floating action button (the button that floats on the screen)
            onPressed: () {},
            child: Text('y'),
            backgroundColor: Color(0xFF42A5F5),
          ),
        ),
      );
    }
  }