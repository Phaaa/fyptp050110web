import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyptp050110web/UserPages/WebHome.dart';
import 'package:fyptp050110web/firebase_options.dart';
import 'package:fyptp050110web/main.dart';

Future loginUsingWebEmailPassword(
    {required String email,
    required String password,
    required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == "user-not-found") {
      print("No User found");
    }
  }
  return null;
}

Future createNewWebUserFirestore(
    {required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address}) async {
  var userDoc = FirebaseFirestore.instance.collection('Users');
  var newUserID = FirebaseAuth.instance.currentUser!.uid;
  userDoc.doc(newUserID).set(
    {
      'Email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'Cart': [],
      'MfaStatus': false,
    },
  );
}

Future registerNewWebUserFirestore(
    {required String newEmail,
    required String newPassword,
    required String newFirstName,
    required String newLastName,
    required String newPhoneNumber,
    required String newAddress,
    required BuildContext context}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: newEmail,
      password: newPassword,
    );
    createNewWebUserFirestore(
        email: newEmail,
        firstName: newFirstName,
        lastName: newLastName,
        phoneNumber: newPhoneNumber,
        address: newAddress);
    await loginUsingWebEmailPassword(
        email: newEmail, password: newPassword, context: context);
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('Entered password is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('Account already exists. Please log in instead.');
    }
  } catch (e) {
    print(e);
  }
}

Stream retrieveProducts() {
  return FirebaseFirestore.instance
      .collection("Products")
      .doc("RandomOne")
      .snapshots();
}

Stream retrieveCart() {
  return FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

Future logoutWebFirebase() async {
  await FirebaseAuth.instance.signOut();
}
