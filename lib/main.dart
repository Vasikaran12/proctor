import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/models/user.dart';
import 'package:proctor/pages/splash_page.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void main() async {
  GoogleSignInAccount? user = google.currentUser;
  if(user != null){
    debugPrint("User: ${user.email}");
    Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addUser(User(id: user.id, name: user.displayName ?? "", email: user.email, phone: ""));
  }else{
    debugPrint("No user");
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proctor',
      navigatorKey: navigationKey,
      scaffoldMessengerKey: SnackBarGlobal.key,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff6849ef, color),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const SplashPage()
    );
  }
}

class SnackBarGlobal {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: const Duration(seconds: 3),
      ));
  }
}