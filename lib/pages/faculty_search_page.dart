import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:proctor/constants/auth_constants.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:proctor/models/student.dart';
import 'package:proctor/providers/user_provider.dart';
import 'package:proctor/widgets/scard.dart';
import 'package:provider/provider.dart';

class FacultyPage extends StatefulWidget {
  const FacultyPage({super.key});

  @override
  State<FacultyPage> createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  bool isloading = true;
  String search = "";
  final _searchcontroller = TextEditingController();
  List<String> filter = ['Name', 'Register Number', 'Email', 'Phone', 'Proctor'];
  String selectedFilter = 'Name';

  Future<List<Student>> fetchStudents() async {
    debugPrint("Try");
    List<Student> l = [];
    try{
      debugPrint("Called");
    Response res = await get(Uri.parse('$url/fetchStudents'));
    debugPrint(res.statusCode.toString());
    if(res.statusCode == 200){
      debugPrint(jsonDecode(res.body).toString());
      List t = jsonDecode(res.body);
      for(int i=0; i<t.length; i++){
        l.add(Student.fromMap(t[i]));
      }
    }
    }catch(e){
      debugPrint(e.toString());
      SnackBarGlobal.show("Error Occured while fetching students list");
    }
    debugPrint(l.toString());
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                          textInputAction: TextInputAction.done,
                          textDirection: TextDirection.ltr,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (val){
                              setState(() {
                                search = val;
                              });
                          },
                          keyboardType: selectedFilter == 'Phone' 
                                        ? TextInputType.number
                                        : selectedFilter == 'Email'
                                        ? TextInputType.emailAddress
                                        : TextInputType.text,
                          controller: _searchcontroller,
                          decoration: const InputDecoration(
                            labelText: "Search",
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                Container(
  decoration: BoxDecoration(
    color: kPrimaryLight,
    borderRadius: BorderRadius.circular(10),
  ),
  child: DropdownButton(
    padding: const EdgeInsets.only(right: 15),
    icon: const Icon(Icons.arrow_drop_down_circle_sharp, color: Colors.white,),
    underline: const SizedBox(),
    alignment: Alignment.topCenter,
    borderRadius: BorderRadius.circular(8),
    dropdownColor: kPrimaryLight,
    value: selectedFilter,
    items: filter
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
            value: e,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ),
        )
        .toList(),
    onChanged: (String? value) => setState(
      () {
        if (value != null) selectedFilter = value;
      },
    ),
  ),
),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03,)
              ],),
          const SizedBox(
            height: 20
          ),
          search.isEmpty
                ? const Expanded(
                  flex: 1,
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 70,color: kPrimaryLight,),
                      SizedBox(height: 20,),
                      Text("Search for Students", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryColor
                      ),),
                    ],
                  ),
                                ),
                ) 
                : 
              Expanded(
                flex: 1,
                child: FutureBuilder<List<Student>>(
                                  future: fetchStudents(),
                                  builder: (context, snapshot){
                                    if (snapshot.connectionState == ConnectionState.waiting){
                                      const Center(child: CircularProgressIndicator());
                                    }else if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                SnackBarGlobal.show("Error while fetching students");
                                        }
                                        if(snapshot.data != null && snapshot.data!.isNotEmpty){
                debugPrint(snapshot.data!.toString());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data!.where((s)
                            {if(selectedFilter == 'Name'){
                              return s.name.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Register Number'){
                              return s.regnum.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Email'){
                              return s.email.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Phone'){
                              return s.phone.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Proctor'){
                              return s.faculty.name.toLowerCase().contains(search.toLowerCase());
                            }else{
                              return false;
                            }
                          }
                        ).isEmpty
                      ? const Center(child: Text("No Student found !", style:  TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                      ),))
                      : ListView(
                        //return Card(child: IdCard(name: snapshot.data![index].name, regnum: snapshot.data![index].regnum, pname: snapshot.data![index].faculty.name, pphone: snapshot.data![index].faculty.phone, pemail: snapshot.data![index].faculty.email));
                        children: snapshot.data!.where((s)
                            {if(selectedFilter == 'Name'){
                              return s.name.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Register Number'){
                              return s.regnum.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Email'){
                              return s.email.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Phone'){
                              return s.phone.toLowerCase().contains(search.toLowerCase());
                            }else if(selectedFilter == 'Proctor'){
                              return s.faculty.name.toLowerCase().contains(search.toLowerCase());
                            }else{
                              return false;
                            }
                          }
                        ).map<Widget>((e){
                          return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SIdCard(name: e.name, phone: e.phone, email: e.email, regnum: e.regnum, pname: e.faculty.name, pphone: e.faculty.phone, pemail: e.faculty.email, showProctor: Provider.of<UserProvider>(context).faculty.email != e.faculty.email,),
                        );
                      }).toList()
                                                    ),
                  );
                                      }else if(snapshot.data == null){
                                            return const Center(child: CircularProgressIndicator());
                                        }
                                        else{
                                          return const Center(child: Text("No students found"));
                                        }
                                        },),
              )
                            ],
                          );
  }
}