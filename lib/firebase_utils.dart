import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseUtils {
  static CollectionReference<Event> getEventsCollection() {
    return FirebaseFirestore.instance
        .collection(Event.collectionName)
        .withConverter<Event>(
          fromFirestore: (snapshot, options) =>
              Event.fromjasonFireStore(snapshot.data()!),
          toFirestore: (event, options) => event.tojasonFireStore(),
        );
  }

  static Future<void> addEventToFireStore(Event event) {
    CollectionReference<Event> collectionRef = getEventsCollection();
    DocumentReference<Event> docRef = collectionRef.doc();
    event.id = docRef.id;
    return docRef.set(event);
  }

  static Future<void> updateFavorite(Event event) {
    return getEventsCollection().doc(event.id).update({
      "is_favorite": event.isFavorite,
    });
  }

  static Future<void> updateEvent(Event event) {
    return getEventsCollection().doc(event.id).update(event.tojasonFireStore());
  }

  static Future<void> deleteEvent(String eventId) {
    return getEventsCollection().doc(eventId).delete();
  }

  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      return null;
    }
  }
}
