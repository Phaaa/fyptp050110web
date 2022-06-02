import 'package:flutter/material.dart';
import 'package:fyptp050110web/WebHome.dart';

class WebKeycaps extends StatefulWidget {
  const WebKeycaps({Key? key}) : super(key: key);

  @override
  State<WebKeycaps> createState() => _WebKeycapsState();
}

class _WebKeycapsState extends State<WebKeycaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WebHome()));
        }),
        actions: [
          Container(
            padding: EdgeInsets.all(5.0),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WebHome()));
              },
              child: const Text("Login"),
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
      body: KeycapsProducts(),
    );
  }
}

class KeycapsProducts extends StatefulWidget {
  const KeycapsProducts({Key? key}) : super(key: key);

  @override
  State<KeycapsProducts> createState() => KeycapsProductsState();
}

class KeycapsProductsState extends State<KeycapsProducts> {
  @override
  Widget build(BuildContext context) {
    return Text("Keycaps here");
  }
}
