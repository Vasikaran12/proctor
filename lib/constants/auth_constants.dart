import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn google = GoogleSignIn();
String url = 'https://proctor-m5dv.onrender.com';
//String url = 'http://192.168.106.70:3000';
var t = google.isSignedIn();