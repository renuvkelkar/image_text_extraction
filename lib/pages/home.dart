import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_text_extraction/model/label_data.dart';

import '../model/data.dart';
import "package:path/path.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? uploadImage;
  String? imageName;

  String? url;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final ref = FirebaseFirestore.instance
      .collection('extractedText')
      .withConverter<DataModel>(
        fromFirestore: (snapshot, _) => DataModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (model, _) => model.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 145, 200),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 188, 5),
        title: Text("Image Text Extractor"),
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
                    "https://img.freepik.com/free-vector/landing-page-image-upload-concept_23-2148298840.jpg?",
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
                        final Reference newref =
                            firebaseStorage.ref().child(img);

                        TaskSnapshot snapshot =
                            await newref.putFile(uploadImage!);
                        url = await snapshot.ref.getDownloadURL();
                        imageName = basename(uploadImage!.path);

                        setState(() {});
                      }
                    },
                    child: Text(
                      "Scan Text",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Extracted Text",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: ref.doc(imageName).snapshots(),
            builder: (context, snapShot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(snapShot.data?.data()?.text ?? "",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              );
            },
          ),
        ]),
      ),
    );
  }
}
