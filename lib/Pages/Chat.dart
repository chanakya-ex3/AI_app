import 'package:ai_app/MyRoutes.dart';
import 'package:ai_app/Widgets/MessageBubble.dart';
import 'package:ai_app/Widgets/NewMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

final _firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String name = "";
  bool isLoaded = false;
  bool isDark = false;
  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    print(text);
    // speak
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  Map<String, String> convertDynamicMapToStringMap(
      Map<String, dynamic> dynamicMap) {
    Map<String, String> stringMap = {};

    dynamicMap.forEach((key, value) {
      if (value is String) {
        stringMap[key] =
            value; // If the value is already a String, keep it as is.
      } else {
        stringMap[key] =
            value.toString(); // Convert non-string values to strings.
      }
    });

    return stringMap;
  }

  Future<String> getDocByID(String id) async {
    final nameD = await _firestore.collection("usernames").doc(id).get();
    String name = nameD.data()!["Name"];
    print(name);
    return name;
  }

  @override
  void initState() {
    getDocByID(FirebaseAuth.instance.currentUser!.uid).then((value) {
      setState(() {
        name = value;
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    String historyid = arguments.toString();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("History",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text("Chat",
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.63,
                          child: isLoaded
                              ? StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("history")
                                      .where("uid",
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .orderBy("time", descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    // if (snapshot.connectionState ==
                                    //     ConnectionState.waiting) {
                                    //   return Center(
                                    //     child: CircularProgressIndicator(
                                    //       color: Colors.white,
                                    //     ),
                                    //   );
                                    // }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No Past Chats",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          "Error Occured",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                            leading: Icon(
                                              CupertinoIcons.chat_bubble_2,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              snapshot.data!.docs[index]
                                                  ["heading"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            trailing: Icon(
                                              CupertinoIcons.delete_simple,
                                              color: Colors.white,
                                              size: 20,
                                            ));
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        )
                      ],
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: ListTile(
                      leading: Text("Settings",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      trailing: isLoaded
                          ? PopupMenuButton(
                              position: PopupMenuPosition.over,
                              icon: Icon(
                                Icons.settings_outlined,
                                color: Colors.white,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    onTap: () {},
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.settings_outlined,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        "Settings",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )),
                                PopupMenuItem(
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacementNamed(
                                          context, MyRoutes.auth);
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )),
                              ],
                            )
                          : CircularProgressIndicator(
                              color: Colors.white,
                            ),
                    )),
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          // title: Text("Homepage"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MyRoutes.home);
                },
                icon: Icon(Icons.home)),
            IconButton(
              icon: Icon(
                  isDark ? Icons.brightness_4 : Icons.brightness_2_outlined),
              onPressed: () {
                speak("Hello hari");
              },
            )
          ],
        ),
        body: isLoaded
            ? Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("queries")
                          .where("uid",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where("category", isEqualTo: historyid)
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return Center(
                        //     child: CircularProgressIndicator(
                        //       color: Theme.of(context).colorScheme.secondary,
                        //     ),
                        //   );
                        // }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return ListView(
                            reverse: true,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Container(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.3),
                                  child:
                                      Image.asset("assets/images/monkey1.png")),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Center(
                                child: Text(
                                  "Hello $name",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                            ],
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("something went wrong"),
                          );
                        }
                        final loadedChat = snapshot.data!.docs;
                        return ListView.builder(
                          reverse: true,
                          itemCount: loadedChat.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(convertDynamicMapToStringMap(
                                loadedChat[index].data()));
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  NewMessage(
                    history: historyid,
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
