import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riders_app/global/global.dart';
import 'package:riders_app/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/error_dialog.dart';
import '../../widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../mainScreens/home_screen.dart';

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
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageUrl = "";
  String completeAddress = "";
  bool checkClick = false;

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            Exception('Location permissions are permanently denied.'));
      }

      if (permission == LocationPermission.denied) {
        return Future.error(Exception('Location permissions are denied.'));
      }
    }

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];
    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;

    return await Geolocator.getCurrentPosition();
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
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          locationController.text.isNotEmpty) {
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
            .child("riders")
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
    FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).set({
      "riderUID": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": nameController.text.trim(),
      "riderAvatarUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
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
                backgroundColor: Color(0xfff5f6fa),
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
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    is0bsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: "My Current Location",
                    is0bsecre: false,
                    enabled: checkClick,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      label: const Text(
                        "Get my current location",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getCurrentLocation();

                        setState(() {
                          checkClick = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
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
