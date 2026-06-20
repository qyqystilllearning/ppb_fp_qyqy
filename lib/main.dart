import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RowColumnPage(),
    );
  }
}

class RowColumnPage extends StatelessWidget {
  const RowColumnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Indonesia Edition 🇮🇩',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange[200],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                padding: EdgeInsets.all(20.0),
                color: Colors.lightBlue[100],
                child: Center(
                  child: Image.asset(
                    'assets/prabowo.png',
                    fit: BoxFit.cover,
                    width: 500,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
            padding: EdgeInsets.all(20.0),
            color: Colors.pink[200],
            child: Text('What image is that', style: TextStyle(fontSize: 16)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.yellow[200],
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(children: [Icon(Icons.account_circle), Text("President")]),
                Column(children: [Icon(Icons.flag), Text("Candidate")]),
                Column(children: [Icon(Icons.groups_rounded), Text("Military")]),
              ],
            ),
          ),
          CounterCard(),
        ],
      ),
    );
  }
}

class CounterCard extends StatefulWidget {
  const CounterCard({super.key});

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  int _counter = 0; // This is the state (data) that changes.

  void _incrementCounter() {
    setState(() {
      _counter++; // Update the state.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.cyan[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Proud Indonesian: $_counter", style: TextStyle(fontSize: 16)),
          Container(
            color: Colors.cyan[200],
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: _incrementCounter,
              icon: Icon(Icons.add, color: Colors.black, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: true, // Keeping the debug banner to match your screenshot
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text(
//             "Indonesia Edition 🇮🇩",
//             style: TextStyle(color: Colors.black87),
//           ),
//           centerTitle: true,
//           backgroundColor: Color(0xFFFCE38A), // Light amber/yellow color from image
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch, // Makes containers fill the width
//               children: [
//                 // 1. The Image Box (Light Blue)
//                 Container(
//                   color: Color(0xFFC7EBF0), // Light blue background
//                   padding: EdgeInsets.all(24.0),
//                   child: Image.asset(
//                     'assets/prabowo.png',
//                     height: 250,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         height: 250,
//                         color: Colors.grey[800],
//                         child: Center(child: Text("Your image goes here", style: TextStyle(color: Colors.white))),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 24), // Spacing between boxes
                
//                 // 2. The Text Box (Light Pink)
//                 Container(
//                   color: Color(0xFFF1C8D4), // Light pink background
//                   padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
//                   child: Text(
//                     "Who is this person?",
//                     style: TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                 ),
//                 SizedBox(height: 24), // Spacing between boxes
                
//                 // 3. The Icon Row Box (Light Yellow)
//                 Container(
//                   color: Color(0xFFFDF1B6), // Light yellow background
//                   padding: EdgeInsets.symmetric(vertical: 24.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spaces icons evenly
//                     children: [
//                       Column(
//                         children: [
//                           Icon(Icons.account_circle, color: Colors.black87),
//                           SizedBox(height: 8),
//                           Text("President", style: TextStyle(color: Colors.black87)),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Icon(Icons.flag, color: Colors.black87), // umbrella icon
//                           SizedBox(height: 8),
//                           Text("Candidate", style: TextStyle(color: Colors.black87)),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Icon(Icons.groups_rounded, color: Colors.black87),
//                           SizedBox(height: 8),
//                           Text("Military", style: TextStyle(color: Colors.black87)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }