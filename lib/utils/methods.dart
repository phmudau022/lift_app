import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>?> getUserDetails() async {
  User? user = FirebaseAuth.instance.currentUser;
  print(user?.email);
  if (user != null) {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
    if (userDocument.exists) {
      return userDocument.data();
    }
  }

  return {};
}
