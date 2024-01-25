import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/models/faculty.dart';
import 'package:proctor/models/user.dart';
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

  Future<List<Faculty>> getProctorNames() async {
     List<Faculty> l = [];
     try{
     Response res = await get(Uri.parse('$url/faculties'));
     if(res.statusCode == 200){
        List lt = jsonDecode(res.body);
        for(int i=0; i<lt.length; i++){
          l.add(Faculty.fromMap(lt[i]));
        }
     }else if(res.statusCode == 500){
            
     }
     else{
        SnackBarGlobal.show("Error occured while fetching proctor names");
     }
     }catch(e){
      debugPrint(e.toString());
     }
     return l;
  }

  Future<Map> checkUser(String email, String name) async {
     Map l = {};
     try{
      Response res = await get(Uri.parse('$url/checkUser?email=$email&&name=$name'));
      if(res.statusCode == 200){
        l =  jsonDecode(res.body);
      }else{
          SnackBarGlobal.show("Error occured while validating student");
      }
     }catch(e){
      debugPrint(e.toString());
     }
     return l;
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
                      if(user.email.contains("student.tce.edu")){
                        
                        setState(() {
                      isloading  = false;
                    });
                        Map map = await checkUser(user.email, user.displayName ?? "");
                        if(map.isNotEmpty){
                          Faculty faculty = Faculty.fromJson(map['faculty']);
                        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addFaculty(faculty);  
                        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).setRegNum(map['regnum']);  
                        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addUser(User(id: user.id, name: user.displayName ?? "", email: user.email, phone: map['phone']));
                        }else{
                        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addUser(User(id: user.id, name: user.displayName ?? "", email: user.email, phone: ""));
                        }
                      }else if(!user.email.contains("student.tce.edu") && user.email.contains("6131")){
                        List<Faculty> l = await getProctorNames();
                        for(int i = 0; i<l.length; i++){
                            if(l[i].email == 'kiit@tce.edu'){
                            //'''l[i].name'''){
                              
                              setState(() {
                                isloading  = false;
                              });
                        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).setFaculty();
                        Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addUser(User(id: user.id, name: l[i].name, email: user.email, phone: ""));
                        break;
                            }
                        }
                      }
                      else{
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