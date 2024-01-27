import 'package:flutter/material.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/pages/faculty_search_page.dart';
import 'package:proctor/pages/faculty_students.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FHomePage extends StatefulWidget{
  const FHomePage({super.key});

  @override
  State<FHomePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<FHomePage> {
  bool isloading = true;

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor:Colors.white,
              indicatorWeight: 8,

              tabs: [
                Tab(icon: Icon(Icons.search, color: Colors.white), child: Text("Student Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),),
                Tab(icon: Icon(Icons.groups, color: Colors.white), child: Text("My Students", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),),),
              ],
            ), // TabBar
            actions: [Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconButton(onPressed: () async {
                setState(() {
                  isloading = true;
                });
                try{
                    await google.signOut();
                    Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).removeStudent();
                }catch(e){
                  SnackBarGlobal.show("Error occured while signing out");
                }
                setState(() {
                  isloading = false;
                });
                      }, icon: const Icon(Icons.login_rounded, color: Colors.white, size: 20,)),
            ),],
            title: Text('Hi, ${Provider.of<UserProvider>(context).faculty.name} !',style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            backgroundColor: kPrimaryColor,
          ), // AppBar
          body: const TabBarView(
          
            children: [
              FacultyPage(),
              FacultyStudentPage()
            ],
          ), // TabBarView
        ), // Scaffold
      );
  }
}