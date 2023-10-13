import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // menu like drawer
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: Icon(
                                    CupertinoIcons.chat_bubble_2,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Chat $index",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Icon(
                                    CupertinoIcons.delete_simple,
                                    color: Colors.white,
                                    size: 20,
                                  ));
                            },
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
                      trailing: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    )),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Homepage"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
        body: Center(
          child: Text("Homepage"),
        ));
  }
}
