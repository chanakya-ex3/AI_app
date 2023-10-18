import 'package:ai_app/MyRoutes.dart';
import 'package:ai_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';

final _firestore = FirebaseFirestore.instance;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String name = "";
  bool isLoaded = false;
  bool isDark = false;

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
        // menu like drawer
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
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, MyRoutes.chat,
                                                  arguments: snapshot
                                                      .data!.docs[index].id);
                                            },
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
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MyRoutes.settings);
                                    },
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
              icon: Icon(
                  isDark ? Icons.brightness_4 : Icons.brightness_2_outlined),
              onPressed: () async {
                print("test");
              },
            )
          ],
        ),
        body: isLoaded
            ? Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Center(
                          child: Text("Yo, $name",
                              style: TextStyle(
                                  fontSize: 25,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Image.asset("assets/images/monkey1.png"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Here are few features",
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            child: ListTile(
                              leading: ClipOval(
                                child: Image.asset(
                                  "assets/images/chatgpt.png",
                                  fit: BoxFit.fill,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              title: Text(
                                "ChatGPT",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              subtitle: Text(
                                "Get smart answers and organized solutions for your queries",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            child: ListTile(
                              leading: ClipOval(
                                child: Image.asset(
                                  "assets/images/dalle.jpg",
                                  fit: BoxFit.fill,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              title: Text(
                                "Dall-E",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              subtitle: Text(
                                "Stay creative and get your imagination to reality",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            child: ListTile(
                              leading: ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  child: Image.asset(
                                    "assets/images/voice.png",
                                    fit: BoxFit.fill,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                              title: Text(
                                "Voice Assistant",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              subtitle: Text(
                                "Don't type, just speak and get your work done",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: GradientSlideToAct(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      borderRadius: 15,
                      onSubmit: () async {
                        String now = DateTime.now().toString().substring(0, 10);
                        final historyRecord = await FirebaseFirestore.instance
                            .collection("history")
                            .add({
                          "heading": "New Message at $now",
                          "uid": FirebaseAuth.instance.currentUser!.uid,
                          "time": Timestamp.now(),
                        });
                        print(historyRecord.id);

                        Navigator.pushReplacementNamed(context, MyRoutes.chat,
                            arguments: historyRecord.id);
                      },
                      text: "Swipe to Explore",
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              )));
  }
}
