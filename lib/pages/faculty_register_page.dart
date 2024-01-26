import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/models/faculty.dart';
import 'package:proctor/models/student.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FRegisterPage extends StatefulWidget {
  const FRegisterPage({super.key});

  @override
  State<FRegisterPage> createState() => _FRegisterPageState();
}

class _FRegisterPageState extends State<FRegisterPage> {
  bool isloading = false;
  bool ispageloading = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  bool isRegNum(String s) => RegExp(
         r'^\d{2}[A-Za-z]{1,3}\d{3}$')
      .hasMatch(s);

  bool isName(String input) => RegExp(r'^[a-zA-Z .]+$').hasMatch(input);

  final List<Faculty> faculties = [];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() async {
    _nameController.text = Provider.of<UserProvider>(context, listen: false).faculty.name;
      _emailController.text = Provider.of<UserProvider>(context, listen: false).faculty.email;
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
      setState(() {
        ispageloading = false; 
      });
  }

  @override
  Widget build(BuildContext context) {
    return ispageloading
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
      ): Scaffold(
        appBar: AppBar(
          actions: [
          isloading
              ? const SizedBox()
              : IconButton(onPressed: () async {
            setState(() {
              isloading  = true;
            });
            await google.signOut();
            
            setState(() {
              isloading  = false;
            });
            Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).removeStudent();
          }, icon: const Icon(Icons.login_rounded)),
          const SizedBox(
            width: 20,
          ),
        ],
          title: const Text(
            "REGISTRATION",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        const Icon(
                          Icons.three_p_rounded,
                          size: 100,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(height: 50),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        enabled: !isloading,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please enter your name";
                          } else if (!isName(val)) {
                            return "Please enter a valid name";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          prefixIcon: Icon(Icons.align_horizontal_left),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField( 
                        enabled: !isloading,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autofocus: false,
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        enabled: !isloading,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          if (val == null || val.isEmpty){
                            return "Please enter your phone number";
                          } else if (!isPhone(val)) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    isloading
                        ? SizedBox(
                            width: kIsWeb
                                ? MediaQuery.of(context).size.width / 3
                                : MediaQuery.of(context).size.width / 2,
                            child: const LinearProgressIndicator())
                        : InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                  debugPrint("Success");
                                  try{
                                    debugPrint({
                                    'name': _nameController.text,
                                    'email': _emailController.text, 
                                    'phone': _phoneController.text,
                                  }.toString());
                                  Map<String, dynamic> data = {
                                    'name': _nameController.text,
                                    'email': _emailController.text, 
                                    'phone': _phoneController.text,
                                  };
                                  Response res = await post(Uri.parse('$url/addFaculty'), 
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(data));
                                  debugPrint("hello1");
                                  if(res.statusCode == 200){
                                    debugPrint("hello ${jsonDecode(res.body)}");
                                    Provider.of<UserProvider>(navigationKey.currentContext!, listen: false).addFaculty(Faculty.fromMap(jsonDecode(res.body)));
                                  }else{
                                    SnackBarGlobal.show("Error while registering user");
                                  }
                                  }catch(e){
                                    debugPrint(e.toString());
                                    SnackBarGlobal.show("Error while registering user");
                                  }
                                
                                setState(() {
                                  isloading = false;
                                });
                              }
                            },
                            child: Container(
                              width: kIsWeb
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}