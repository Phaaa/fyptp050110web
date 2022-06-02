import 'package:flutter/material.dart';
import 'package:fyptp050110web/WebHome.dart';

class WebSwitches extends StatefulWidget {
  const WebSwitches({Key? key}) : super(key: key);

  @override
  State<WebSwitches> createState() => _WebSwitchesState();
}

class _WebSwitchesState extends State<WebSwitches> {
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
      body: SwitchesProducts(),
    );
  }
}

class SwitchesProducts extends StatefulWidget {
  const SwitchesProducts({Key? key}) : super(key: key);

  @override
  State<SwitchesProducts> createState() => SwitchesProductsState();
}

class SwitchesProductsState extends State<SwitchesProducts> {
  @override
  Widget build(BuildContext context) {
    return Text("Switches here");
  }
}
