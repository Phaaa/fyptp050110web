import 'package:flutter/material.dart';
import 'package:fyptp050110web/WebHome.dart';

class WebKeyboards extends StatefulWidget {
  const WebKeyboards({Key? key}) : super(key: key);

  @override
  State<WebKeyboards> createState() => _WebKeyboardsState();
}

class _WebKeyboardsState extends State<WebKeyboards> {
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
      body: KeyboardsProducts(),
    );
  }
}

class KeyboardsProducts extends StatefulWidget {
  const KeyboardsProducts({Key? key}) : super(key: key);

  @override
  State<KeyboardsProducts> createState() => KeyboardsProductsState();
}

class KeyboardsProductsState extends State<KeyboardsProducts> {
  @override
  Widget build(BuildContext context) {
    return Text("Keyboards here");
  }
}
