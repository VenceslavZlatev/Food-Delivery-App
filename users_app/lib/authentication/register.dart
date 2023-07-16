import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/error_dialog.dart';
import '../../widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../main screens/home_screen.dart';
import '../widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //TextEditingController confirmPasswordController = TextEditingController();
  //TextEditingController phoneController = TextEditingController();
  //TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = "";
  bool checkClick = false;

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> formvalidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please select an image.",
          );
        },
      );
    } else {
      if (passwordController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty) {
        //start uploading the image
        showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Making the account",
            );
          },
        );
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        fStorage.Reference reference = fStorage.FirebaseStorage.instance
            .ref()
            .child("users")
            .child(fileName);
        fStorage.UploadTask uploadTask =
            reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          sellerImageUrl = url;
          //seve info to firestore
          authenticateSellerAndSignUp();
        });
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please fill all the required fields",
            );
          },
        );
      }
    }
  }

  Future<void> authenticateSellerAndSignUp() async {
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        },
      );
    });
    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        //send user to home page
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photoUrl": sellerImageUrl,
      "status": "approved",
      "userCart": ['garbageValue']
    });
    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            splashColor: Colors.white,
            child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.10,
                backgroundColor: const Color(0xfff5f6fa),
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.10,
                        color: Colors.grey,
                      )
                    : null),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    is0bsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    is0bsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    is0bsecre: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff94b723),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                formvalidation();
              },
              child: const Text(
                "Sign up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
