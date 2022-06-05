import 'package:flutter/material.dart';
import 'package:fyptp050110web/FirebaseOps/FirebaseOps.dart';
import 'package:fyptp050110web/Login/WebLogin.dart';

class WebHome extends StatefulWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const WebLogin()));
              },
              child: const Text("Login"),
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: retrieveProducts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something Went Wrong"));
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
                    color: Colors.amber,
                    width: double.infinity,
                    height: 60,
                    child: const Center(
                      child: Text("Login to be able to add to cart."),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
      ),
    );
  }
}
