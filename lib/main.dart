import 'package:ppb_fp/models/note_database.dart';
import 'package:ppb_fp/pages/notes_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
      child: const MyApp(),
    )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage()
    );
  }
}

// class RowColumnPage extends StatelessWidget {
//   const RowColumnPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQueryData = MediaQuery.of(context);
//     double screenWidth = mediaQueryData.size.width;
//     double screenHeight = mediaQueryData.size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Indonesia Edition 🇮🇩',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.orange[200],
//         centerTitle: true,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             child: AspectRatio(
//               aspectRatio: 1.0,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
//                 padding: EdgeInsets.all(20.0),
//                 color: Colors.lightBlue[100],
//                 child: Center(
//                   child: Image.asset(
//                     'assets/prabowo.png',
//                     fit: BoxFit.cover,
//                     width: 500,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
//             padding: EdgeInsets.all(20.0),
//             color: Colors.pink[200],
//             child: Text('What image is that', style: TextStyle(fontSize: 16)),
//           ),
//           // Container(
//           //   width: MediaQuery.of(context).size.width,
//           //   color: Colors.yellow[200],
//           //   padding: EdgeInsets.all(20.0),
//           //   margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: <Widget>[
//           //       Column(children: [Icon(Icons.account_circle), Text("President")]),
//           //       Column(children: [Icon(Icons.flag), Text("Candidate")]),
//           //       Column(children: [Icon(Icons.groups_rounded), Text("Military")]),
//           //     ],
//           //   ),
//           // ),
//           // CounterCard(),
//           FormImage(),
//         ],
//       ),
//     );
//   }
// }

// // class CounterCard extends StatefulWidget {
// //   const CounterCard({super.key});

// //   @override
// //   State<CounterCard> createState() => _CounterCardState();
// // }

// // class _CounterCardState extends State<CounterCard> {
// //   int _counter = 0; // This is the state (data) that changes.

// //   void _incrementCounter() {
// //     setState(() {
// //       _counter++; // Update the state.
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
// //       padding: EdgeInsets.all(20.0),
// //       width: MediaQuery.of(context).size.width,
// //       color: Colors.cyan[100],
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text("Proud Indonesian: $_counter", style: TextStyle(fontSize: 16)),
// //           Container(
// //             color: Colors.cyan[200],
// //             padding: EdgeInsets.all(5.0),
// //             child: IconButton(
// //               onPressed: _incrementCounter,
// //               icon: Icon(Icons.add, color: Colors.black, size: 16),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// class FormImage extends StatefulWidget {
//   const FormImage({super.key});

//   @override
//   State<FormImage> createState() => _FormImageState();
// }

// class _FormImageState extends State<FormImage> {
//   final _formKey = GlobalKey<FormState>();
//   String _answer = '';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: InputDecoration(label: Text("Enter your answer")),
//                       validator: (value) => value!.isEmpty ? 'Please answer' : null,
//                       onSaved: (value) => setState(() {
//                         _answer = value!;
//                       }),
//                     ),
//                     ElevatedButton(onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _formKey.currentState!.save();
//                         _formKey.currentState!.reset();
//                       }

//                     }, child: Text("Answer"))
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
//                 padding: EdgeInsets.all(20.0),
//                 color: Colors.yellow[200],
//                 child: Text("Your answer: $_answer"))

//           ],
//         )
//     );
//   }
// }