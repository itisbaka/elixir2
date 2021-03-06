import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elixir2/pages/register/register_home.dart';
import 'package:elixir2/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../UserModels/hotel_user_model.dart';



class RegistrationHotel extends StatefulWidget {
  const RegistrationHotel({Key? key}) : super(key: key);

  @override
  _RegistrationHotelState createState() => _RegistrationHotelState();
}

class _RegistrationHotelState extends State<RegistrationHotel> {
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;


  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final hotelNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //hotel name field
    final hotelNameField = TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        controller: hotelNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          hotelNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Hotel Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));


    //email field
    final emailField = TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          hotelNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for registration");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          hotelNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.pink,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
     resizeToAvoidBottomInset: false,
     backgroundColor: Colors.transparent,
     appBar: AppBar(
       backgroundColor: Colors.cyan.shade700,
       leading:
       IconButton( onPressed: (){
         gotoHome(context);
       },
           icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
     ),
     body: Container(
       decoration: BoxDecoration(
         image: DecorationImage(
             image: const AssetImage("assets/Background.jpg"),
             fit: BoxFit.cover,
             colorFilter: ColorFilter.mode(
               Colors.black.withOpacity(0.5),
               BlendMode.darken,
             )
         ),
       ),
       child: Column(
         children:[
           Container(
             height: 160,

             decoration: const BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('assets/ELIXIR_logo.png'),
               ),
               borderRadius: BorderRadius.only(
                 bottomRight: Radius.circular(50),
                 bottomLeft: Radius.circular(50),
                 topRight: Radius.circular(50),
                 topLeft: Radius.circular(50),
               ),
               color: Colors.transparent,
             ), 
           ),
           Container(
             child: Padding(
                 padding: const EdgeInsets.all(36.0),
                child: Form(
                   key: _formKey,
                 child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                    /* SizedBox(
                         height: 180,
                         child: Image.asset(
                           "assets/logo.png",
                           fit: BoxFit.contain,
                         )),*/
                     const SizedBox(height: 45),
                     hotelNameField,
                     const SizedBox(height: 20),
                     emailField,
                     const SizedBox(height: 20),
                     passwordField,
                     const SizedBox(height: 20),
                     confirmPasswordField,
                     const SizedBox(height: 20),
                     signUpButton,
                     const SizedBox(height: 15),
                   ],
           ),
                ),
             ),
           )
         ]
       ),
     )
   );
  }
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? hotel_user = _auth.currentUser;

    HotelUserModel userModel = HotelUserModel();

    // writing all the values
    userModel.email = hotel_user!.email;
    userModel.uid = hotel_user.uid;
    userModel.hotelName = hotelNameEditingController.text;
   // userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
        .collection("Hotel_users")
        .doc(hotel_user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const WelcomePage()),
            (route) => false);
  }
  void gotoHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const RegisterHome()),
  );
}

