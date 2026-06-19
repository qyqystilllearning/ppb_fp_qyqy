import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, // Keeping the debug banner to match your screenshot
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Indonesia Edition 🇮🇩",
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFFCE38A), // Light amber/yellow color from image
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Makes containers fill the width
              children: [
                // 1. The Image Box (Light Blue)
                Container(
                  color: Color(0xFFC7EBF0), // Light blue background
                  padding: EdgeInsets.all(24.0),
                  child: Image.asset(
                    'assets/prabowo.png',
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        color: Colors.grey[800],
                        child: Center(child: Text("Your image goes here", style: TextStyle(color: Colors.white))),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24), // Spacing between boxes
                
                // 2. The Text Box (Light Pink)
                Container(
                  color: Color(0xFFF1C8D4), // Light pink background
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Text(
                    "Who is this person?",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                SizedBox(height: 24), // Spacing between boxes
                
                // 3. The Icon Row Box (Light Yellow)
                Container(
                  color: Color(0xFFFDF1B6), // Light yellow background
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spaces icons evenly
                    children: [
                      Column(
                        children: [
                          Icon(Icons.account_circle, color: Colors.black87),
                          SizedBox(height: 8),
                          Text("President", style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.flag, color: Colors.black87), // umbrella icon
                          SizedBox(height: 8),
                          Text("Candidate", style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.groups_rounded, color: Colors.black87),
                          SizedBox(height: 8),
                          Text("Military", style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}