import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/Register/WebRegister.dart';
import 'package:fyptp050110web/WebHome.dart';
import 'package:fyptp050110web/WebHomeLoggedIn.dart';

class WebLogin extends StatelessWidget {
  const WebLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => WebHome()));
        }),
      ),
      body: WebLoginPage(),
    );
  }
}

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({Key? key}) : super(key: key);

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MfaAppName",
            style: TextStyle(
                color: Colors.amber,
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
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.amber[200],
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () async {
                await loginUsingWebEmailPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => WebHomeLoggedIn()));
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
          const Text("Dont have an account? Register Here"),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.amber[200],
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WebRegister()));
              },
              child: const Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
