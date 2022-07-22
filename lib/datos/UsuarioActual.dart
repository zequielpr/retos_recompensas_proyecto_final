import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser{
  static User? currentUser;

  static setCurrentUser(){
    currentUser = FirebaseAuth.instance.currentUser;
  }




  static String getIdCurrentUser(){
    return currentUser?.uid as String;
  }
}