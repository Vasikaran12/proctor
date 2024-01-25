import 'package:flutter/material.dart';
import 'package:proctor/models/faculty.dart';
import 'package:proctor/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user = User(id: "", name: "", email: "", phone: "");
  Faculty _faculty = Faculty(name: "", email: "", phone: "");
  
  bool _isFaculty = false;
  String _regNum = "";
  
  User get user => _user;
  bool get isFaculty => _isFaculty;
  String get regNum => _regNum;
  Faculty get faculty => _faculty;

  void addUser(User user){
    _user = user;
    notifyListeners();
  }

  void addFaculty(Faculty faculty){
    _faculty = faculty;
    notifyListeners();
  }

  void removeUser(){
    _user = User(id: "", name: "", email: "", phone: ""); 
    _faculty = Faculty(name: "", email: "", phone: "");
    _isFaculty = false;
    _regNum = "";
    notifyListeners();
  }

  void setRegNum(String regNum){
    _regNum = regNum;
    notifyListeners();
  }

  void setFaculty(){
    _isFaculty = true;
    notifyListeners();
  }
}