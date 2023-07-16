import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/widgets/simple_app_bar.dart';
import 'package:users_app/widgets/snack_bar.dart';
import 'package:users_app/widgets/text_field.dart';

// ignore: must_be_immutable
class SaveAddressScreen extends StatelessWidget {
  final _name = TextEditingController();
  final _phonenumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;

  SaveAddressScreen({super.key});

  getUserLocationAddress() async {
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
        desiredAccuracy: LocationAccuracy.high);

    position = newPosition;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark pMark = placemarks![0];

    String fullAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare} ${pMark.subLocality} ${pMark.locality} ${pMark.subAdministrativeArea} ${pMark.administrativeArea}, ${pMark.postalCode} ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text =
        '${pMark.subThoroughfare} ${pMark.thoroughfare} ${pMark.subLocality} ${pMark.locality}';

    _city.text =
        '${pMark.subAdministrativeArea} ${pMark.administrativeArea} ${pMark.postalCode}';

    _state.text = '${pMark.country}';

    _completeAddress.text = fullAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "iFood",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Save address: ",
                  style: TextStyle(color: Colors.black, fontFamily: "Gilroy"),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
              ),
              title: SizedBox(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: "What is your address?",
                    hintStyle:
                        TextStyle(color: Colors.black, fontFamily: "Gilroy"),
                  ),
                ),
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff94b723),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                //getCurrentLocationWithAddress
                getUserLocationAddress();
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              label: const Text(
                "Get my location",
                style: TextStyle(fontFamily: "Gilroy", color: Colors.white),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "Phone number",
                    controller: _phonenumber,
                  ),
                  MyTextField(
                    hint: "City",
                    controller: _city,
                  ),
                  MyTextField(
                    hint: "State / Country",
                    controller: _state,
                  ),
                  MyTextField(
                    hint: "Address line",
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: "Complete address",
                    controller: _completeAddress,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 200,
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
                  if (formKey.currentState!.validate()) {
                    final model = Address(
                      name: _name.text.trim(),
                      state: _state.text.trim(),
                      fullAddress: _completeAddress.text.trim(),
                      phoneNumber: _phonenumber.text.trim(),
                      flatNumber: _flatNumber.text.trim(),
                      city: _city.text.trim(),
                      lat: position!.latitude,
                      lng: position!.longitude,
                    ).toJson();

                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(DateTime.now().millisecondsSinceEpoch.toString())
                        .set(model)
                        .then((value) {
                      formKey.currentState!.reset();
                      _name.clear();
                      _state.clear();
                      _phonenumber.clear();
                      _completeAddress.clear();
                      _flatNumber.clear();
                      _city.clear();
                      awesomeSnack(context, "Success",
                          "New address have been saved", ContentType.success);
                    });
                  }
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontFamily: "Gilroy"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
