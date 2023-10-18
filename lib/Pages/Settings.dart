import 'package:ai_app/MyRoutes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _changeNameController = TextEditingController();

  void changeName() async {
    String name = _changeNameController.text;
    if (name.isNotEmpty && name != "" && name.trim().isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("usernames")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"Name": name});
      _changeNameController.clear();
      FocusScope.of(context).unfocus();
      SnackBar snackBar = SnackBar(
        content: Text("Name Changed"),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Named Updated successfully")));
    }
  }

  void setPassword() async {
    try {
      print(FirebaseAuth.instance.currentUser!.email.toString());
      FirebaseAuth.instance.sendPasswordResetEmail(
          email: FirebaseAuth.instance.currentUser!.email.toString());
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reset link sent to your email")));
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyRoutes.home);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("Settings"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(
                color: Theme.of(context).colorScheme.background,
                child: ExpansionTile(
                  title: Text(
                    "Change Name",
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _changeNameController,
                        decoration: InputDecoration(
                            hintText: "Enter New Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            changeName();
                          },
                          child: Text("Change Name")),
                    )
                  ],
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.background,
                child: ListTile(
                  title: Text(
                    "Change Password",
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                        onPressed: () {
                          setPassword();
                        },
                        child: Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.background,
                child: ListTile(
                  title: Text(
                    "Forgot Password",
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                        onPressed: () {
                          setPassword();
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
