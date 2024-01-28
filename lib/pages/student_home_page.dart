import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/pages/notification_page.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/widgets/card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text('Hi, ${Provider.of<UserProvider>(context).student.name} !',style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          isloading
          ? const SizedBox()
          : IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const NotifyPage()));
          }, icon: const Icon(Icons.notifications_active, size: 30,)),
          const SizedBox(width: 10,),
          isloading
          ? const SizedBox()
          : IconButton(onPressed: () async {
            setState(() {
              isloading  = true;
            });
            await google.signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? t = prefs.getString('token');
            if(t != null && t.isNotEmpty){
              Response res = await get(
                Uri.parse('$url/removetoken?token=$t')
              );
              if(res.statusCode == 200){
                debugPrint("Success");
              }else{
                debugPrint("Error in removing token");
              }
            }
            setState(() {
              isloading  = false;
            });
            Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).removeStudent();
          }, icon: const Icon(Icons.login_rounded, size: 30,)),
          const SizedBox(width: 15,)
        ],
      ),
      body: isloading
      ? const Center(child: CircularProgressIndicator(),)
      : Center(
        child: SingleChildScrollView(
          child: IdCard(name: Provider.of<UserProvider>(context).student.name, 
          regnum: Provider.of<UserProvider>(context).student.regnum, 
          pname: Provider.of<UserProvider>(context).student.faculty.name, 
          pphone: Provider.of<UserProvider>(context).student.faculty.phone, 
          pemail: Provider.of<UserProvider>(context).student.faculty.email),
        )
      ),
    );
  }
}