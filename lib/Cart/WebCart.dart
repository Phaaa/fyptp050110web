import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyptp050110web/Checkout/WebCheckout.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/UserPages/WebHomeLoggedIn.dart';

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
              MaterialPageRoute(builder: (context) => const WebHomeLoggedIn()));
        }),
      ),
      body: StreamBuilder(
        stream: retrieveUserDocFields(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }
          if (snapshot.hasData) {
            var data = snapshot.data;
            List cartList = data['Cart'];
            num cartTotal = 0;
            cartList.forEach((cartList) {
              cartTotal += cartList['Total'];
            });
            if (cartList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text("Cart Is Empty.")),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 70,
                        color: Colors.amber,
                        child: const Center(
                          child: Text("Cart"),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CartListTile(itemsList: cartList[index]);
                        },
                        itemCount: cartList.length,
                      ),
                      Container(
                        child: Text("Cart Total: " + cartTotal.toString()),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const WebCheckout()));
                        },
                        child: const Text("Check Out"),
                        fillColor: Colors.amber[200],
                      ),
                    ],
                  ),
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CartListTile extends StatefulWidget {
  const CartListTile({
    Key? key,
    required this.itemsList,
  }) : super(key: key);

  final itemsList;

  @override
  State<CartListTile> createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  var quantityCounter = 0;
  late TextEditingController _quantityController =
      TextEditingController(text: widget.itemsList['Quantity'].toString());
  late final VoidCallback onChanged;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        tileColor: Colors.red,
        title: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.itemsList['Name']),
              Container(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price per Unit: RM" +
                        widget.itemsList['Price'].toString() +
                        " "),
                    Text("Total: RM" +
                        (widget.itemsList['Price'] *
                                int.parse(_quantityController.text))
                            .toString()),
                  ],
                ),
              )
            ],
          ),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            onPressed: () {
              var current = int.parse(_quantityController.text);
              current--;
              if (current > 0) {
                var currentUserDoc = FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                currentUserDoc.update(
                  {
                    "Cart": FieldValue.arrayRemove([
                      {
                        "Name": widget.itemsList['Name'],
                        "Quantity": widget.itemsList['Quantity'],
                        "Price": widget.itemsList['Price'],
                        "Total": widget.itemsList['Total'],
                      }
                    ])
                  },
                );
                setState(() {
                  _quantityController.text = current.toString();
                });
                currentUserDoc.update(
                  {
                    "Cart": FieldValue.arrayUnion([
                      {
                        "Name": widget.itemsList['Name'],
                        "Quantity": current,
                        "Price": widget.itemsList['Price'],
                        "Total": widget.itemsList['Price'] *
                            int.parse(_quantityController.text),
                      }
                    ])
                  },
                );
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const WebCart()));
              }
              if (current == 0) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Remove from cart?"),
                    content: Text("Would you like to remove " +
                        (widget.itemsList['Name'].toString()) +
                        " from cart?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          var currentUserDoc = FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid);
                          currentUserDoc.update(
                            {
                              "Cart": FieldValue.arrayRemove([
                                {
                                  "Name": widget.itemsList['Name'],
                                  "Quantity": widget.itemsList['Quantity'],
                                  "Price": widget.itemsList['Price'],
                                  "Total": widget.itemsList['Total'],
                                }
                              ])
                            },
                          );
                          Navigator.pop(context, 'Yes');
                        },
                        child: const Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _quantityController.text =
                                widget.itemsList['Quantity'].toString();
                          });
                          Navigator.pop(context, 'No');
                        },
                        child: const Text("No"),
                      )
                    ],
                  ),
                );
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
              focusNode: AlwaysDisabledFocusNode(),
            ),
          ),
          IconButton(
            onPressed: () {
              var current = int.parse(_quantityController.text);
              current++;
              var currentUserDoc = FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.uid);
              currentUserDoc.update(
                {
                  "Cart": FieldValue.arrayRemove([
                    {
                      "Name": widget.itemsList['Name'],
                      "Quantity": widget.itemsList['Quantity'],
                      "Price": widget.itemsList['Price'],
                      "Total": widget.itemsList['Total'],
                    }
                  ])
                },
              );
              setState(() {
                _quantityController.text = current.toString();
              });
              currentUserDoc.update(
                {
                  "Cart": FieldValue.arrayUnion([
                    {
                      "Name": widget.itemsList['Name'],
                      "Quantity": current,
                      "Price": widget.itemsList['Price'],
                      "Total": widget.itemsList['Price'] *
                          int.parse(_quantityController.text),
                    }
                  ])
                },
              );
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const WebCart()));
            },
            icon: const Icon(Icons.add_circle),
          ),
        ]),
      ),
    );
  }
}
