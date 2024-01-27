import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/firebase_options.dart';
import 'package:proctor/pages/splash_page.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:proctor/services.dart/local_notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotificationServices.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = await FirebaseMessaging.instance.getToken();

  debugPrint(token.toString());

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token??"");

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) async {
    debugPrint("Message hello : $msg");
    try{
    if(await google.isSignedIn()){
      SnackBarGlobal.showNotification(msg.notification!.title ?? "", msg.notification!.body ?? "");
    }}catch(e){
      debugPrint(e.toString());
    }
  });

  FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? msg) async {
      if (msg != null) {
        try{
          if(await google.isSignedIn()){
            SnackBarGlobal.showNotification(msg.notification!.title ?? "", msg.notification!.body ?? "");
          }}catch(e){
            debugPrint(e.toString());
        }
      }
    });

    FirebaseMessaging.onMessage.listen((msg) {
      debugPrint('listen message');
            SnackBarGlobal.showNotification(msg.notification!.title ?? "", msg.notification!.body ?? "");
      LocalNotificationServices.createNotification(msg);
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  static void showNotification(String title, String message) {
    key.currentState!
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(MaterialBanner(
        actions: const [SizedBox()],
        leading: const Icon(
          Icons.notifications,
          color: Colors.yellow,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        
                        barrierDismissible: false,
                        context: navigationKey.currentContext!,
                        builder:(context) => AlertDialog(
                          
                          title: Text(title, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                          content: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryLight,
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500), maxLines: null,),
                                )),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        "Close",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                  ),
                          ],
                        ));
                      ScaffoldMessenger.of(navigationKey.currentContext!)
                          .hideCurrentMaterialBanner();
                    },
                    child: Text(
                        "Open",
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ScaffoldMessenger.of(navigationKey.currentContext!)
                          .hideCurrentMaterialBanner();
                    },
                    color: Colors.white,
                  ),
                  //const SizedBox(width: 6.0),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900],
      ));
  }
}