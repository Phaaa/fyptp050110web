import 'package:flutter/material.dart';
import 'package:fyptp050110web/Cart/WebCart.dart';

class WebCheckout extends StatefulWidget {
  const WebCheckout({Key? key}) : super(key: key);

  @override
  State<WebCheckout> createState() => _WebCheckoutState();
}

class _WebCheckoutState extends State<WebCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WebCart()));
        }),
      ),
      body: const Center(
        child: Text("Checkout Page"),
      ),
    );
  }
}
