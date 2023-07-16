import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//int value for the number picker
int currentIntValue = 1;
//late final int? value;
