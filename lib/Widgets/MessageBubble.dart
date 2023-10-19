import 'package:ai_app/Widgets/threedots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MessageBubble extends StatefulWidget {
  Map<String, String> data;

  MessageBubble(this.data);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    print(text);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    // widget.data["type"] == "voice" && widget.data["response"] == ""
    //     ? speak(widget.data["response"]!)
    //     : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.data["type"] == "voice" && widget.data["response"] == ""
    //     ? speak(widget.data["response"]!)
    //     : null;
    // super.initState();
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
          (widget.data["type"] == "text" || widget.data["type"] == "voice")
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85),
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Card(
                          color: Colors.white,
                          child: ListTile(
                            // leading:
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/chatgpt.png',
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "ChatGPT",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.data["response"] == ""
                                  ? Center(
                                      child: ThreeDots(),
                                    )
                                  : Text(
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
                        // leading: ,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/images/dalle.jpg",
                                fit: BoxFit.fill,
                                height: 22,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Dall-E",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                widget.data["response"]!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  );
                                },
                                fit: BoxFit.fill,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
