import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get a reference to the 'notes' collection in Firebase
  // If this collection doesn't exist yet, Firebase automatically creates it!
  final CollectionReference notesCollection = FirebaseFirestore.instance.collection('notes');

  // CREATE: Add a new note to the cloud
  Future<void> addNote(String noteText) async {
    await notesCollection.add({
      'text': noteText,
      'timestamp': Timestamp.now(), // Saves the exact time it was created
    });
  }

  // READ: Get a real-time stream of all notes from the cloud
  // A Stream automatically pushes updates to your app whenever data changes on the internet!
  Stream<QuerySnapshot> getNotesStream() {
    return notesCollection.orderBy('timestamp', descending: true).snapshots();
  }
}
