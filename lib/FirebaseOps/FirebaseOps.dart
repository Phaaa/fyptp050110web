import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyptp050110web/Dialogs/Dialogs.dart';
import 'package:fyptp050110web/main.dart';

var currentUserId = FirebaseAuth.instance.currentUser!.uid;
var currentUserDoc =
    FirebaseFirestore.instance.collection("Users").doc(currentUserId);

Future loginUsingWebEmailPassword(
    {required String email,
    required String password,
    required BuildContext context}) async {
  String errorTitle, errorContent;
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    currentUserDoc =
        FirebaseFirestore.instance.collection("Users").doc(currentUserId);
  } on FirebaseAuthException catch (e) {
    if (e.code == "user-not-found") {
      errorTitle = "Error: User not found";
      errorContent =
          "Account does not exist in our system. Please register an account with us.";
      showGeneralErrorDialog(context, errorTitle, errorContent);
    } else {
      errorTitle = "Error: " + e.code;
      errorContent = e.message.toString();
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
  userDoc.doc(currentUserId).set(
    {
      'Email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'Cart': [],
      'MfaStatus': false,
      'MfaUserId': false,
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
  String errorTitle, errorContent;
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: newEmail,
      password: newPassword,
    );
    await loginUsingWebEmailPassword(
        email: newEmail, password: newPassword, context: context);
    createNewWebUserFirestore(
        email: newEmail,
        firstName: newFirstName,
        lastName: newLastName,
        phoneNumber: newPhoneNumber,
        address: newAddress);
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      errorTitle = "Error: Weak Password";
      errorContent = "Password is too weak. Please use a stronger one";
      showGeneralErrorDialog(context, errorTitle, errorContent);
    } else if (e.code == 'email-already-in-use') {
      errorTitle = "Error: Email already in use";
      errorContent = "Please sign in with a differnet email";
      showGeneralErrorDialog(context, errorTitle, errorContent);
    } else {
      errorTitle = "Error: " + e.code;
      errorContent = e.message.toString();
      showGeneralErrorDialog(context, errorTitle, errorContent);
    }
  } catch (e) {
    errorTitle = e.toString();
    errorContent = e.toString();
    showGeneralErrorDialog(context, errorTitle, errorContent);
  }
}

Stream retrieveProducts() {
  return FirebaseFirestore.instance
      .collection("Products")
      .doc("RandomOne")
      .snapshots();
}

Stream retrieveUserDocFields() {
  return FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

Stream retrieveMfa({required String authAccount}) {
  FirebaseApp mfaFirebase = Firebase.app('mfaFirebase');
  return FirebaseFirestore.instanceFor(app: mfaFirebase)
      .collection("Auth")
      .doc(authAccount)
      .snapshots();
}

Future logoutWebFirebase() async {
  await FirebaseAuth.instance.signOut();
}

Future pairMfa(
    {required String email,
    required String password,
    required BuildContext context}) async {
  String errorTitle, errorContent;
  FirebaseApp mfaFirebase = Firebase.app('mfaFirebase');
  FirebaseAuth authForMfaFirebase = FirebaseAuth.instanceFor(app: mfaFirebase);
  var userDoc = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  try {
    await authForMfaFirebase.signInWithEmailAndPassword(
        email: email, password: password);

    userDoc.update(
      {'MfaUserId': authForMfaFirebase.currentUser!.uid, 'MfaStatus': true},
    );
    await authForMfaFirebase.signOut();
    String successTitle = "Success!";
    String successContent = "Paired to MFA App successfully";
    return showGeneralSuccessDialog(context, successTitle, successContent);
  } on FirebaseAuthException catch (e) {
    if (e.code == "user-not-found") {
      errorTitle = "Error: User not found";
      errorContent =
          "Account does not exist in our system. Please register an account with us from the mobile authenticator app.";
      showGeneralErrorDialog(context, errorTitle, errorContent);
    } else {
      errorTitle = "Error: " + e.code;
      errorContent = e.message.toString();
      showGeneralErrorDialog(context, errorTitle, errorContent);
    }
  }
  return null;
}
