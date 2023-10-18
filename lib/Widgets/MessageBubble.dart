import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  Map<String, String> data;

  MessageBubble(this.data);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85),
                margin: EdgeInsets.only(top: 10, right: 10),
                child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data["query"]!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ),
          widget.data["type"] == "text"
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85),
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/chatgpt.png',
                              width: 20,
                            ),
                            title: Text(
                              "ChatGPT",
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data["response"]!,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ))),
                )
              : Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9),
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: Card(
                      color: const Color.fromARGB(255, 98, 175, 214),
                      child: ListTile(
                        leading: ClipOval(
                          child: Image.asset(
                            "assets/images/dalle.jpg",
                            fit: BoxFit.fill,
                            height: 22,
                          ),
                        ),
                        title: Text(
                          "Dall-E",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            widget.data["response"]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
