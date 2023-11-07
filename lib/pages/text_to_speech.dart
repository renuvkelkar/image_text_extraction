import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import '../model/text_data.dart';

class TextHome extends StatefulWidget {
  const TextHome({super.key});

  @override
  State<TextHome> createState() => _TextHomeState();
}

class _TextHomeState extends State<TextHome> {
  final TextEditingController _textController = TextEditingController();
  String? url;

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final ref = FirebaseFirestore.instance
      .collection('text_to_speech')
      .withConverter<TextDataModel>(
        fromFirestore: (snapshot, _) => TextDataModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (model, _) => model.toJson(),
      );

  String? docId;
  String? downloadUrl;

//I add the data inside firestore, the plugin will create the file inside text_to_speech/documentId.mp3
//On adding the text I get the docID
//I perform download operation on text_to_speech/docID.mp3
//I play the file using audio_player

  bool isAudioAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Text to speech converter"),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.yellow,
                border: Border.all(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: _textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter the Text',
                  contentPadding: EdgeInsets.only(top: 15, left: 10),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      if (_textController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter the text'),
                          ),
                        );
                      } else {
                        final doc = await ref
                            .add(TextDataModel(
                          text: _textController.text,
                        ))
                            .then((doc) async {
                          setState(() {
                            docId = doc.id;
                          });

                          Future.delayed(Duration(seconds: 5), () async {
                            downloadUrl = await FirebaseStorage.instance
                                .ref()
                                .child('text_to_speech/$docId.mp3')
                                .getDownloadURL();
                            setState(() {
                              isAudioAvailable = true;
                            });
                            _textController.clear();
                          });
                        });
                      }

                      // Clear the text field to prepare for next input.
                      _textController.clear();
                    },
                  ),
                ),
              ),
            ),
            isAudioAvailable
                ? Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                        onPressed: () async {
                          final player = AudioPlayer();
                          player.play(UrlSource("downloadUrl" ?? ""));
                        },
                        child: Text(
                          "Speak",
                          style: Theme.of(context).textTheme.titleMedium,
                        )))
                : Text("Audio Preparing/not available"),
          ],
        ));
  }
}
