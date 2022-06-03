import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/UserPages/WebHomeLoggedIn.dart';
import 'package:fyptp050110web/main.dart';

class WebSettings extends StatefulWidget {
  const WebSettings({Key? key}) : super(key: key);

  @override
  State<WebSettings> createState() => _WebSettingsState();
}

class _WebSettingsState extends State<WebSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()));
        }),
      ),
      body: StreamBuilder(
        stream: retrieveCart(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData) {
            var data = snapshot.data;
            var mfaStatus = data['MfaStatus'];
            var userDoc = FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid);
            return Row(
              children: [
                const Text("Enable MFA"),
                Switch(
                  value: mfaStatus,
                  activeColor: Colors.green[200],
                  inactiveThumbColor: Colors.red[200],
                  onChanged: (value) {
                    setState(() {
                      mfaStatus = value;
                    });
                    userDoc.update(
                      {
                        'MfaStatus': value,
                      },
                    );
                  },
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
