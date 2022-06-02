import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';

class WebRegister extends StatelessWidget {
  const WebRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: WebRegistrationPage());
  }
}

class WebRegistrationPage extends StatefulWidget {
  const WebRegistrationPage({Key? key}) : super(key: key);

  @override
  State<WebRegistrationPage> createState() => WebRegistrationPageState();
}

class WebRegistrationPageState extends State<WebRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _newWebEmailController = TextEditingController();
    TextEditingController _newWebPasswordController = TextEditingController();
    TextEditingController _newWebFirstNameController = TextEditingController();
    TextEditingController _newWebLastNameController = TextEditingController();
    TextEditingController _newWebAddressController = TextEditingController();
    TextEditingController _newWebPhoneNumberController =
        TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              "Register",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: _newWebEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _newWebPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.password, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _newWebFirstNameController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "First Name",
                  prefixIcon: Icon(Icons.password, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _newWebLastNameController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Last Name",
                  prefixIcon: Icon(Icons.password, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _newWebPhoneNumberController,
              obscureText: true,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(13),
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]'),
                ),
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.password, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: _newWebAddressController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Address",
                  prefixIcon: Icon(Icons.password, color: Colors.black)),
            ),
            const SizedBox(
              height: 26.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.amber[200],
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onPressed: () async {
                  registerNewWebUserFirestore(
                      newEmail: _newWebEmailController.text,
                      newPassword: _newWebPasswordController.text,
                      newFirstName: _newWebFirstNameController.text,
                      newLastName: _newWebLastNameController.text,
                      newPhoneNumber: _newWebPhoneNumberController.text,
                      newAddress: _newWebAddressController.text,
                      context: context);
                },
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
