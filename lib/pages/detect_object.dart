import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_text_extraction/model/label_data.dart';

import '../model/data.dart';
import "package:path/path.dart";

import '../model/object_data.dart';

class Detectobject extends StatefulWidget {
  const Detectobject({super.key});

  @override
  State<Detectobject> createState() => _DetectobjectState();
}

class _DetectobjectState extends State<Detectobject> {
  File? uploadImage;
  String? imageName;
  String? docId;

  String? url;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final ObjectRef = FirebaseFirestore.instance
      .collection('detectedObjects')
      .withConverter<ObjectData>(
        fromFirestore: (snapshot, _) => ObjectData.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (model, _) => model.toJson(),
      );

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 170, 150),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 188, 5),
        title: const Text("Detected Object"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          uploadImage != null
              ? Image.file(uploadImage!)
              : Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  child: Image.network(
                    "https://img.freepik.com/free-vector/image-upload-illustrated-background-landing-page_52683-24623.jpg?",
                    fit: BoxFit.cover,
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 40,
                width: 150,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 188, 5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextButton(
                    onPressed: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (image == null) return;
                      uploadImage = File(image.path);

                      setState(() {});
                    },
                    child: Text(
                      "Pick Image",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),
              Container(
                height: 40,
                width: 150,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 243, 188, 5),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextButton(
                    onPressed: () async {
                      if (uploadImage != null) {
                        String? img = basename(uploadImage!.path);
                        final Reference ref = firebaseStorage.ref().child(img);

                        TaskSnapshot snapshot = await ref.putFile(uploadImage!);
                        url = await snapshot.ref.getDownloadURL();
                        imageName = basename(uploadImage!.path);

                        setState(() {});
                      }
                    },
                    child: Text(
                      "Scan Image",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Object detected",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          if (imageName != null)
            StreamBuilder(
              stream: ObjectRef.where('file',
                      isEqualTo:
                          "gs://devrel-extensions-testing.appspot.com/${imageName}")
                  .snapshots(),
              builder: (context, snapShot) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapShot.data?.docs.length,
                      itemBuilder: (context, Index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 200,
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapShot.data?.docs[Index]
                                      .data()
                                      .objects
                                      ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return Text(
                                    snapShot.data?.docs[Index]
                                            .data()
                                            .objects?[index]
                                            .toString() ??
                                        "",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white));
                              },
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
        ]),
      ),
    );
  }
}
