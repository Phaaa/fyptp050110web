import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/UserPages/WebPairingLogin.dart';
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
              MaterialPageRoute(builder: (context) => const MyApp()));
        }),
      ),
      body: Center(
        child: StreamBuilder(
          stream: retrieveUserDocFields(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.hasData) {
              var data = snapshot.data;
              var mfaStatus = data['MfaStatus'];
              if (!mfaStatus) {
                return Container(
                  width: 200,
                  height: 100,
                  color: Colors.amber,
                  child: RawMaterialButton(
                    child: const Text("Enable Mfa"),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const WebPairingLogin()));
                    },
                  ),
                );
              } else {
                return Container(
                  width: 200,
                  height: 100,
                  color: Colors.amber,
                  child: RawMaterialButton(
                    child: const Text("Disable Mfa"),
                    onPressed: () {
                      currentUserDoc.update(
                        {
                          "MfaStatus": false,
                          "MfaUserId": false,
                        },
                      );
                    },
                  ),
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
