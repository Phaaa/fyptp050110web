import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyptp050110web/main.dart';

class WebPayment extends StatefulWidget {
  const WebPayment({Key? key}) : super(key: key);

  @override
  State<WebPayment> createState() => _WebPaymentState();
}

class _WebPaymentState extends State<WebPayment> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _cardNumberController = TextEditingController();
    TextEditingController _cvvController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()));
        }),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Payment Page",
            style: TextStyle(fontSize: 30),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Card Number: "),
              SizedBox(
                width: 500,
                child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(16),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    hintText: "6-Digit OTP",
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("Expiry date: "),
              SizedBox(
                width: 500,
                child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    hintText: "Expiration Date",
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("CVV: "),
              SizedBox(
                width: 500,
                child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    hintText: "***",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            width: 200,
            color: Colors.amber,
            child: RawMaterialButton(
              onPressed: () {
                var userDoc = FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                userDoc.update(
                  {
                    'Cart': [],
                  },
                );
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Thanks <3"),
                    content: const Text(
                        "Payment Successful! Thanks for supporting us!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
              child: const Text("Pay"),
            ),
          )
        ],
      )),
    );
  }
}
