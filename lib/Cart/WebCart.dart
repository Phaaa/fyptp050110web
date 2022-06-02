import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fyptp050110web/Checkout/WebCheckout.dart';
import 'package:fyptp050110web/WebHome.dart';

class WebCart extends StatefulWidget {
  const WebCart({Key? key}) : super(key: key);

  @override
  State<WebCart> createState() => _WebCartState();
}

class _WebCartState extends State<WebCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WebHome()));
        }),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text("Cart Page"),
            ),
            Container(
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => WebCheckout()));
                },
                child: Text("Check Out"),
                fillColor: Colors.amber[200],
              ),
            )
          ],
        ),
      ),
    );
  }
}
