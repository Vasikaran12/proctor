import 'package:flutter/material.dart';
import 'package:proctor/pages/FacultyPage.dart';
import 'package:proctor/pages/home_page.dart';
import 'package:proctor/pages/login_page.dart';
import 'package:proctor/pages/register_page.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState(){
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Provider.of<UserProvider>(context).user.id.isNotEmpty
      ? Provider.of<UserProvider>(context).regNum.isEmpty 
      ? Provider.of<UserProvider>(context).isFaculty
      ? const FacultyPage()
      : const RegisterPage()
      : const HomePage()
      : const LoginPage();
  }
}