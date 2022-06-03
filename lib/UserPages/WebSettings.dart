import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      body: Center(child: Text("Settings Page")),
    );
  }
}
