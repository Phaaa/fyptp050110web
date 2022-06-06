import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyptp050110web/Cart/WebCart.dart';
import 'package:fyptp050110web/Dialogs/Dialogs.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/UserPages/WebProfile.dart';
import 'package:fyptp050110web/UserPages/WebSettings.dart';
import 'package:fyptp050110web/main.dart';

class WebHomeLoggedIn extends StatefulWidget {
  const WebHomeLoggedIn({Key? key}) : super(key: key);

  @override
  State<WebHomeLoggedIn> createState() => _WebHomeLoggedInState();
}

class _WebHomeLoggedInState extends State<WebHomeLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.amber),
              child: Container(
                child: RawMaterialButton(
                  onPressed: () async {
                    await logoutWebFirebase();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                  child: const Text("Logout"),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.portrait),
              title: const Text("Profile"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const WebProfile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const WebSettings()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const WebCart()));
              },
              child: const Text("Cart"),
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: retrieveProducts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }
          if (snapshot.hasData) {
            var data = snapshot.data;
            List keyboardsList = data['KeyboardModels'];
            List keycapList = data['KeycapModels'];
            List switchesList = data['SwitchesModels'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.green,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 70,
                          color: Colors.amber,
                          child: const Center(
                            child: Text("Keyboards"),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ModelListTile(
                                itemsList: keyboardsList[index]);
                          },
                          itemCount: keyboardsList.length,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.green,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 70,
                          color: Colors.amber,
                          child: const Center(
                            child: Text("Keycaps"),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ModelListTile(itemsList: keycapList[index]);
                          },
                          itemCount: keycapList.length,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.green,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 70,
                          color: Colors.amber,
                          child: const Center(
                            child: Text("Switches"),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ModelListTile(
                                itemsList: switchesList[index]);
                          },
                          itemCount: switchesList.length,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ModelListTile extends StatefulWidget {
  const ModelListTile({
    Key? key,
    required this.itemsList,
  }) : super(key: key);

  final itemsList;

  @override
  State<ModelListTile> createState() => _ModelListTileState();
}

class _ModelListTileState extends State<ModelListTile> {
  var quantityCounter = 0;
  TextEditingController _quantityController = TextEditingController(text: "0");
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        tileColor: Colors.red,
        title: InkWell(
          onTap: () {
            print(widget.itemsList['Description']);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.itemsList['Name']),
              Text("RM" + widget.itemsList['Price'].toString())
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                var current = int.parse(_quantityController.text);
                if (current > 0) {
                  current--;
                  setState(() {
                    _quantityController.text = current.toString();
                  });
                }
              },
              icon: const Icon(Icons.remove_circle),
            ),
            SizedBox(
              width: 30,
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                ],
                controller: _quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: () {
                var current = int.parse(_quantityController.text);
                current++;
                setState(() {
                  _quantityController.text = current.toString();
                });
              },
              icon: const Icon(Icons.add_circle),
            ),
            RawMaterialButton(
              onPressed: () async {
                var current = int.parse(_quantityController.text);
                if (current > 0) {
                  var currentUser = FirebaseAuth.instance.currentUser!.uid;
                  var userDoc = FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser);
                  userDoc.update({
                    "Cart": FieldValue.arrayUnion([
                      {
                        "Name": widget.itemsList['Name'],
                        "Quantity": int.parse(_quantityController.text),
                        "Price": widget.itemsList['Price'],
                        "Total": int.parse(_quantityController.text) *
                            widget.itemsList['Price']
                      }
                    ])
                  });
                  String successTitle = "Success!";
                  String successContent = "Added to cart!";
                  showGeneralSuccessDialog(
                      context, successTitle, successContent);
                  setState(() {
                    _quantityController.text = "0";
                  });
                } else {
                  String errorTitle = "Invalid Quantity";
                  String errorContent =
                      "Specify a valid quantity to add to cart";
                  showGeneralErrorDialog(context, errorTitle, errorContent);
                }
              },
              child: const Text("Add To Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
