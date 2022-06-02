import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyptp050110web/WebHome.dart';
import 'package:fyptp050110web/WebHomeLoggedIn.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(name: 'mfaFirebase', options: mfaFirebase);
  debugPrint(mfaFirebase.toString());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebFirebaseInit(),
    );
  }
}

class WebFirebaseInit extends StatefulWidget {
  const WebFirebaseInit({Key? key}) : super(key: key);

  @override
  State<WebFirebaseInit> createState() => _WebFirebaseInitState();
}

class _WebFirebaseInitState extends State<WebFirebaseInit> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return WebHomeLoggedIn();
                } else {
                  return WebHome();
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
