import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      db
          .collection("users")
          .doc(user.uid)
          .update({"deviceTokens": FieldValue.arrayUnion([fcmToken])});
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String displayName}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user!;
    await user.updateDisplayName(displayName);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final data = {
      "uid": user.uid,
      "username": displayName,
      "email": user.email,
      "imageURL": '',
      "deviceTokens": [fcmToken ?? ""]
    };

    db.collection("users").doc(user.uid).set(data);
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
