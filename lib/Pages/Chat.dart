import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String name = "";
  bool isLoaded = false;

  Future<String> getDocByID(String id) async {
    final nameD = await _firestore.collection("usernames").doc(id).get();
    String name = nameD.data()!["Name"];
    print(name);
    return name;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocByID(FirebaseAuth.instance.currentUser!.uid).then((value) {
      setState(() {
        name = value;
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(),
        body: isLoaded
            ? Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Center(
                        child: Text(
                          "Hello $name",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Image.asset("assets/images/monkey1.png"))
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.secondary),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter a search term',
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIcon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      IconButton(
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            print("pressed mic");
                          },
                          icon: Icon(
                            Icons.mic_outlined,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ));
  }
}
