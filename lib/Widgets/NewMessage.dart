import 'dart:convert';

import 'package:ai_app/ApiFunctions.dart';
import 'package:ai_app/Pages/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

  //speech to text related variables
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  Future<String> getImageResponse(String message) async {
    final apiKey = ApiFunctions.apiKey; // Replace with your OpenAI API key

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({"prompt": message, "n": 1, "size": "1024x1024"}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data['data'][0]['url'].toString();
    } else {
      throw Exception('Failed to get chat response');
    }
  }

  Future<String> getChatResponse(String message) async {
    final apiKey = ApiFunctions.apiKey; // Replace with your OpenAI API key

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].toString();
    } else {
      throw Exception('Failed to get chat response');
    }
  }

  Future<String> _isImage(String message) async {
    final apiKey = ApiFunctions.apiKey; // Replace with your OpenAI API key

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content":
                "Does this message want to generate an AI image, art or picture? '$message'. Simply answer in a yes or no."
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].toString();
    } else {
      throw Exception('Failed to get chat response');
    }
  }

  void submit(String type) async {
    query = _controller.text;
    print("sending");
    print(type);
    if (query.isNotEmpty && query != "" && query.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      setState(() {
        _controller.clear();
        isQueryExmpty = true;
      });
      String response = "";
      try {
        await FirebaseFirestore.instance
            .collection("history")
            .doc(NewMessage.historyid)
            .update({
          "time": Timestamp.now(),
          "heading":
              (query.length > 20) ? query.substring(0, 20) + "..." : query,
        });
        final data =
            await FirebaseFirestore.instance.collection("queries").add({
          "query": query,
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "response": "",
          "type": type,
          "category": NewMessage.historyid,
          "time": Timestamp.now(),
        });
        await FirebaseFirestore.instance
            .collection("history")
            .doc(NewMessage.historyid)
            .update({
          "time": Timestamp.now(),
          "heading":
              (query.length > 20) ? query.substring(0, 20) + "..." : query,
        });
        // print(_isImage(query));
        String temp = await _isImage(query);
        if (temp.toLowerCase().contains("yes")) {
          type = "image";

          response = await getImageResponse(query);

          // print(response);
        } else {

          response = await getChatResponse(query);
        }

        if (type == "voice") {
          ChatPage.voiceNeed = true;
        }
        await FirebaseFirestore.instance
            .collection("queries")
            .doc(data.id)
            .update({
          "type": type,
          "response": response,
        });
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unable to send message")));
      }
      print("done");
    }
  }

  //Speech to text related functions
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    if (_speechToText.isNotListening) {
      print("stopped");
    }
  }

  Future<void> _stopListening() async {
    print("stopped 1");
    await _speechToText.stop();
    print("stopped 2");
    setState(() {});
    print("stopped 3");

    submit("voice");

    print("stopped 4");
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    setState(() {
      _controller.text = result.recognizedWords;
    });
    if (_speechToText.isNotListening) {
      print("stopped 5");
      submit("voice");
    }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
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
              suffixIcon: isQueryExmpty
                  ? IconButton(
                      onPressed: () async {
                        _speechToText.isNotListening
                            ? await _startListening()
                            : await _stopListening();
                      },
                      tooltip: 'Listen',
                      icon: Icon(_speechToText.isNotListening
                          ? Icons.mic_off
                          : Icons.mic),
                      color: Colors.white,
                    )
                  : IconButton(
                      onPressed: () {
                        submit("text");
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
            ),
          ),
        ));
  }
}
