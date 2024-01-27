import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/models/faculty.dart';
import 'package:proctor/models/student.dart';
import 'package:proctor/pages/faculty_home_page.dart';
import 'package:proctor/pages/student_home_page.dart';
import 'package:proctor/pages/login_page.dart';
import 'package:proctor/pages/faculty_register_page.dart';
import 'package:proctor/pages/student_register_page.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isloading = true;
  
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      validateStudent();
    });
  }

  void validateStudent() async {
      var signedIn = await google.isSignedIn();
      if(signedIn){
        GoogleSignInAccount? user = await google.signInSilently();
        if(user != null){
                      if(user.email.contains("tce.edu") || user.email.contains("vasikaran6131@gmail.com") || user.email.contains("vineesha.v0102@gmail.com")){
                        if(user.email.contains("student.tce.edu")){
                          try{
                            Response res = await get(Uri.parse('$url/checkStudent?email=${user.email}'));
                            if(res.statusCode == 200){
                              debugPrint(jsonDecode(res.body).toString());
                              Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addStudent(Student.fromMap(jsonDecode(res.body)));
                            }else if(res.statusCode == 400){
                              debugPrint("Success");
                              Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addStudent(Student(name: user.displayName ?? "", email: user.email, phone: "", regnum: "", faculty: Faculty(name: "", email: "", phone: "")));
                            }else{
                              SnackBarGlobal.show("Error occured while validating student");
                            }
                          }catch(e){
                            debugPrint(e.toString());
                          }
                        }else{
                          List<Faculty> faculties = [];
                          try{
                            Response res = await get(Uri.parse('$url/faculties'));
                            if(res.statusCode == 200){
                                List lt = jsonDecode(res.body);
                                for(int i=0; i<lt.length; i++){
                                  faculties.add(Faculty.fromMap(lt[i]));
                                }
                            }else{
                                SnackBarGlobal.show("Error occured while fetching proctor names");
                            }
                          }catch(e){
                            debugPrint(e.toString());
                          }
                          for(int i = 0; i<faculties.length; i++){
                            debugPrint(faculties[i].email);
                            if(user.email == faculties[i].email){
                              debugPrint("Success 1212");
                              Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).setFaculty();
                              try{
                                Response res = await get(Uri.parse('$url/checkFaculty?email=${user.email}'));
                                if(res.statusCode == 200){
                                  Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addFaculty(Faculty.fromJson(res.body));
                                }else if(res.statusCode == 400){
                                  debugPrint("Success");
                                  Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addFaculty(Faculty(name: user.displayName ?? "", email: user.email, phone: "",));
                                }else{
                                  SnackBarGlobal.show("Error occured while validating student");
                                }
                              }catch(e){
                                debugPrint(e.toString());
                              }
                              break;
                            }
                          }
                        }                      
                      }else{
                        SnackBarGlobal.show("Please continue with your college E-Mail ID");
                        await google.signOut();
                      }
                    }
      }
      setState(() {
        isloading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
      ? Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_pin_rounded, size: 165, color: kPrimaryColor,),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                child: const LinearProgressIndicator(
                  minHeight: 10,
                  color: kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      )
      : Provider.of<UserProvider>(context).student.email.isNotEmpty || Provider.of<UserProvider>(context).faculty.email.isNotEmpty
      ? Provider.of<UserProvider>(context).student.regnum.isEmpty 
      ? Provider.of<UserProvider>(context).isFaculty
      ? Provider.of<UserProvider>(context).faculty.phone.isEmpty
      ? const FRegisterPage()
      : const FacultyPage()
      : const RegisterPage()
      : const HomePage()
      : const LoginPage();
  }
}