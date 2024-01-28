import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/pages/faculty_search_page.dart';
import 'package:proctor/pages/faculty_students.dart';
import 'package:proctor/pages/notification_page.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FHomePage extends StatefulWidget{
  const FHomePage({super.key});

  @override
  State<FHomePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<FHomePage> {
  bool isloading = false;

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: isloading
            ? null
            : const TabBar(
              indicatorColor:Colors.white,
              indicatorWeight: 8,

              tabs: [
                Tab(icon: Icon(Icons.search, color: Colors.white), child: Text("Student Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),),
                Tab(icon: Icon(Icons.groups, color: Colors.white), child: Text("My Students", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),),
              ],
            ), // TabBar
            actions: [
          isloading
          ? const SizedBox()
          : IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const NotifyPage()));
          }, icon: const Icon(Icons.notifications_active, size: 30, color: Colors.white)),
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
          }, icon: const Icon(Icons.login_rounded, size: 30, color: Colors.white)),
          const SizedBox(width: 15,)
        ],
            title: Text('Hi, ${Provider.of<UserProvider>(context).faculty.name} !',style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            backgroundColor: kPrimaryColor,
          ), // AppBar
          body: isloading
      ? const Center(child: CircularProgressIndicator(),)
      : const TabBarView(
          
            children: [
              FacultyPage(),
              FacultyStudentPage()
            ],
          ), // TabBarView
        ), // Scaffold
      );
  }
}