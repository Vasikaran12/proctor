import 'package:flutter/material.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () async {
            setState(() {
              isloading  = true;
            });
            await google.signOut();
            
            setState(() {
              isloading  = false;
            });
            Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).removeUser();
          }, icon: const Icon(Icons.login_rounded))
        ],
      ),
      body: Center(
        child: Text(Provider.of<UserProvider>(context).user.name)
      ),
    );
  }
}