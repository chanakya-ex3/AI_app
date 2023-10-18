import 'dart:convert';

import 'package:ai_app/ApiFunctions.dart';
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

  void submit() async {
    query = _controller.text;

    if (query.isNotEmpty && query != "" && query.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      setState(() {
        _controller.clear();
      });
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
          "type": "text",
          "category": NewMessage.historyid,
          "time": Timestamp.now(),
        });
        String response = await getChatResponse(query);
        await FirebaseFirestore.instance
            .collection("history")
            .doc(NewMessage.historyid)
            .update({
          "time": Timestamp.now(),
          "heading":
              (query.length > 20) ? query.substring(0, 20) + "..." : query,
        });
        await FirebaseFirestore.instance
            .collection("queries")
            .doc(data.id)
            .update({
          "response": response,
        });
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid mail or password")));
      }
      print("done");
      
    }
  }

  //Speech to text related functions
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    setState(() {
      _controller.text = result.recognizedWords;
    });
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
              print(query);
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
                  ? 
                  IconButton(
                      onPressed:
                        // If not yet listening for speech start, otherwise stop
                        _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                    tooltip: 'Listen',
                    icon: Icon(_speechToText.isNotListening
                        ? Icons.mic_off
                        : Icons.mic),)
                  : IconButton(
                      onPressed: () {
                        submit();
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
