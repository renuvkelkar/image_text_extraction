import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_text_extraction/model/label_data.dart';

import '../model/data.dart';
import "package:path/path.dart";

class ImageLabelPage extends StatefulWidget {
  const ImageLabelPage({super.key});

  @override
  State<ImageLabelPage> createState() => _ImageLabelPageState();
}

class _ImageLabelPageState extends State<ImageLabelPage> {
  File? uploadImage;
  String? imageName;

  String? url;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final labelRef = FirebaseFirestore.instance
      .collection('imageLabels')
      .withConverter<LabeledImage>(
        fromFirestore: (snapshot, _) => LabeledImage.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (model, _) => model.toJson(),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 170, 150),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 188, 5),
        title: const Text("Image Labelling"),
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
                        print("imageName");
                        print(imageName);

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
            "Image Labels",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: labelRef.doc(imageName).snapshots(),
            builder: (context, snapShot) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapShot.data?.data()?.labels!.length,
                    itemBuilder: (context, Index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapShot.data?.data()?.labels![Index] ?? "",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
