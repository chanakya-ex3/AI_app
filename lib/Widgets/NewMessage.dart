import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  static String historyid = "";
  NewMessage({String history = "null", super.key}) {
    historyid = history;
  }

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  bool isQueryExmpty = true;

  TextEditingController _controller = TextEditingController();
  String query = "";

  void submit() async {
    query = _controller.text;
    if (query.isNotEmpty && query != "" && query.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();

      await FirebaseFirestore.instance.collection("queries").add({
        "query": query,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "response": "hello, how can i help you?",
        "type": "text",
        "category": NewMessage.historyid,
        "time": Timestamp.now(),
      });
      print("done");
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: TextField(
            onChanged: (value) {
              query = value;
              setState(() {
                if (query.isEmpty) {
                  isQueryExmpty = true;
                } else {
                  isQueryExmpty = false;
                }
              });
            },
            controller: _controller,
            minLines: 1,
            maxLines: 10,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Type a message',
              hintStyle: TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                  onPressed: () {
                    submit();
                  },
                  icon: Icon(
                    isQueryExmpty ? Icons.mic : Icons.send,
                    color: Colors.white,
                  )),
            ),
          ),
        ));
  }
}
