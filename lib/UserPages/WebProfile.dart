import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyptp050110web/Dialogs/Dialogs.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/main.dart';

class WebProfile extends StatefulWidget {
  const WebProfile({Key? key}) : super(key: key);

  @override
  State<WebProfile> createState() => _WebProfileState();
}

class _WebProfileState extends State<WebProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyApp()));
        }),
      ),
      body: StreamBuilder(
        stream: retrieveUserDocFields(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData) {
            var data = snapshot.data;
            var userDoc = FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid);
            var address = data['Address'];
            var firstName = data['FirstName'];
            var lastName = data['LastName'];
            var phoneNumber = data['PhoneNumber'];
            TextEditingController _webFirstNameController =
                TextEditingController(text: firstName);
            TextEditingController _webLastNameController =
                TextEditingController(text: lastName);
            TextEditingController _webAddressController =
                TextEditingController(text: address);
            TextEditingController _webPhoneNumberController =
                TextEditingController(text: phoneNumber);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("First Name:"),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  controller: _webFirstNameController,
                                  decoration: const InputDecoration(
                                    hintText: "First Name",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Last Name:"),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  controller: _webLastNameController,
                                  decoration: const InputDecoration(
                                    hintText: "First Name",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Phone Number:"),
                          SizedBox(
                            width: 500,
                            child: TextField(
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(13),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              keyboardType: TextInputType.number,
                              controller: _webPhoneNumberController,
                              decoration: const InputDecoration(
                                hintText: "Phone Number",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Address :"),
                          SizedBox(
                            width: 500,
                            child: TextField(
                              controller: _webAddressController,
                              decoration: const InputDecoration(
                                hintText: "Address",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      SizedBox(
                        width: 250,
                        child: RawMaterialButton(
                          onPressed: () {
                            userDoc.update(
                              {
                                "FirstName": _webFirstNameController.text,
                                "LastName": _webLastNameController.text,
                                "PhoneNumber": _webPhoneNumberController.text,
                                "Address": _webAddressController.text,
                              },
                            );
                            String successTitle = "Success!";
                            String successContent = "Profile updated!";
                            showGeneralSuccessDialog(
                                context, successTitle, successContent);
                          },
                          child: const Text("Update Information"),
                          fillColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
