import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'models/event.dart';

class FirebaseUtils {
  static CollectionReference<Event> getEventsCollection() {
    return FirebaseFirestore.instance
        .collection('events')
        .withConverter<Event>(
          fromFirestore: (snapshot, options) {
            return Event.fromJsonFireStore(snapshot.data()!);
          },
          toFirestore: (event, options) {
            return event.toJsonFireStore();
          },
        );
  }

  static Future<void> addEvent(Event event) {
    var collection = getEventsCollection();
    var docRef = collection.doc();
    event.id = docRef.id;
    event.userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return docRef.set(event);
  }

  static Future<void> deleteEvent(String id) {
    var collection = getEventsCollection();
    return collection.doc(id).delete();
  }

  static Future<void> updateEvent(Event event) {
    var collection = getEventsCollection();
    return collection.doc(event.id).update(event.toJsonFireStore());
  }

  static Stream<QuerySnapshot<Event>> getEventsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return getEventsCollection().where('userId', isEqualTo: userId).snapshots();
  }

  // إضافة الدالة اللي كانت ناقصة وعاملة إيرور في شاشة اللوجين
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign In: $e");
      return null;
    }
  }
}
