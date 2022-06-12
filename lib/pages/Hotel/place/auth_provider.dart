import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:elixir2/pages/UserModels/hotel_user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
class AuthProvider extends StatefulWidget{
  @override
  AuthClass createState() => AuthClass() ;

}
class AuthClass extends State<AuthProvider> {

  User? user = FirebaseAuth.instance.currentUser;
  HotelUserModel loggedInUser = HotelUserModel();
  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance.collection("Hotel_user").doc(user!.uid).get().then((value){
      this.loggedInUser=HotelUserModel.fromMap(value.data());
      setState((){});
    });
  }
  //SignOut
  void logOut() async {
   FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}