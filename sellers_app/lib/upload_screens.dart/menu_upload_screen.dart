import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global/global.dart';
import 'package:flutter_application_1/mainScreens/home_screen.dart';
import 'package:flutter_application_1/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import '../widgets/error_dialog.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInforController = TextEditingController();
  TextEditingController titleInforController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Menu",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.grey,
              size: 200.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextButton(
                onPressed: () {
                  takeImage(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff94b723),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: const Text(
                  "Add New Menu",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: "Gilroy"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Menu Image",
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: captureImageWithCamera,
                child: const Text(
                  "Take picture with Camera",
                  style: TextStyle(color: Color(0xff231f20)),
                ),
              ),
              SimpleDialogOption(
                onPressed: pickImageFromGalery,
                child: const Text(
                  "Select Image From Galery",
                  style: TextStyle(color: Color(0xff231f20)),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGalery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);

    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Uploading New Menu",
          style: TextStyle(fontFamily: "Gilroy", fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            clearMenuUploadForm();
            defaultScreen();
          },
        ),
        actions: [
          TextButton(
            onPressed: uploading ? null : () => validateUploadForm(),
            child: const Text(
              "Add",
              style: TextStyle(
                  color: Color(0xff94b723),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Gilroy"),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearaProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path),
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInforController,
                decoration: const InputDecoration(
                    hintText: "Menu Info",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Color(0xff231f20),
            thickness: 0.5,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleInforController,
                decoration: const InputDecoration(
                    hintText: "Menu Title",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          )
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      shortInforController.clear();
      titleInforController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInforController.text.isNotEmpty &&
          titleInforController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        //start uplading the image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save info to firebase
        saveInfo(
            downloadUrl, shortInforController.text, titleInforController.text);
        //go on a new screen where it should say "uploading done" and a button to go to the newly created menu
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please write title and information for menu.",
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please pick an image for menu.",
          );
        },
      );
    }
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("menus");
    storageRef.UploadTask uploadTask =
        reference.child("$uniqueIdName.jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveInfo(String downloadUrl, shortInfo, String titleInfo) async {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus");

    ref.doc(uniqueIdName).set({
      "menusID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInforController.text.toString(),
      "menuTitle": titleInforController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl
    });
    clearMenuUploadForm();
    setState(() {
      uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
