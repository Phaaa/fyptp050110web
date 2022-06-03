import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyptp050110web/Cart/WebCart.dart';
import 'package:fyptp050110web/Checkout/WebPayment.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';

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
      body: Center(
        child: StreamBuilder(
          stream: retrieveCart(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.hasData) {
              var userData = snapshot.data;
              String authAccount = userData['MfaUserId'];
              return StreamBuilder(
                stream: retrieveMfa(authAccount: authAccount),
                builder: (context, AsyncSnapshot snapshot2) {
                  if (snapshot2.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          const Text("Something went wrong with MFA APP"),
                          Text(snapshot2.error.toString())
                        ],
                      ),
                    );
                  }
                  if (snapshot2.hasData) {
                    var mfaUserData = snapshot2.data;
                    String otp = mfaUserData['MfaOtp'];
                    TextEditingController _otpController =
                        TextEditingController();
                    return SizedBox(
                      width: 450,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("OTP: "),
                            SizedBox(
                              width: 450,
                              child: TextField(
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                ],
                                keyboardType: TextInputType.number,
                                controller: _otpController,
                                decoration: const InputDecoration(
                                  hintText: "6-Digit OTP",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Container(
                              color: Colors.amber,
                              width: 450,
                              child: RawMaterialButton(
                                onPressed: () {
                                  var otpInput = _otpController.text;
                                  if (otpInput == otp) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text("Success!"),
                                        content: const Text(
                                            "Yay! OTP validation successful."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebPayment()));
                                            },
                                            child: const Text("OK"),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text("Error"),
                                        content: const Text("Wrong OTP"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text("OK"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Authenticate Pruchase"),
                              ),
                            )
                          ]),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
