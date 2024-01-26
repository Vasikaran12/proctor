import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/models/faculty.dart';
import 'package:proctor/models/student.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your aesthetic elements here
            const Icon(
                  Icons.three_p_rounded,
                  size: 150,
                  color: kPrimaryColor,
                ),
                const SizedBox(height: 100),
            isloading
              ? const CircularProgressIndicator()
              : SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MaterialButton(
                color: kPrimaryColor,
                onPressed: () async{
                    setState(() {
                      isloading  = true;
                    });
                    var user = await google.signIn();
                    if(user != null){
                      if(user.email.contains("tce.edu") || user.email.contains("vasikaran6131@gmail.com")){
                        if(user.email.contains("student.tce.edu")){
                          try{
                            Response res = await get(Uri.parse('$url/checkStudent?email=${user.email}'));
                            if(res.statusCode == 200){
                              debugPrint(jsonDecode(res.body));
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
                    setState(() {
                      isloading  = false;
                    });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/google.png', // Replace with your Google logo image
                        height: 50,
                        width: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text('CONTINUE WITH GOOGLE', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}