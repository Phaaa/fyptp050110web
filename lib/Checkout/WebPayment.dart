import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fyptp050110web/Checkout/WebCheckout.dart';
import 'package:fyptp050110web/main.dart';

class WebPayment extends StatefulWidget {
  const WebPayment({Key? key}) : super(key: key);

  @override
  State<WebPayment> createState() => _WebPaymentState();
}

class _WebPaymentState extends State<WebPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()));
        }),
      ),
      body: Center(
          child: Column(
        children: [
          const Text("Payment Page"),
        ],
      )),
    );
  }
}
