import 'package:flutter/material.dart';
import 'package:fyptp050110web/Dialogs/Dialogs.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/UserPages/WebSettings.dart';

class WebPairingLogin extends StatefulWidget {
  const WebPairingLogin({Key? key}) : super(key: key);

  @override
  State<WebPairingLogin> createState() => _WebPairingLoginState();
}

class _WebPairingLoginState extends State<WebPairingLogin> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WebSettings()));
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MfaAppName",
              style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Login",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.password, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onPressed: () async {
                  if (_passwordController.text.isEmpty ||
                      _emailController.text.isEmpty) {
                    String errorTitle = "Error";
                    String errorContent =
                        "Email and Password text fields cannot be empty";
                    showGeneralErrorDialog(context, errorTitle, errorContent);
                  } else {
                    await pairMfa(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context);
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
