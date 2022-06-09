import 'package:elixir2/pages/register/register_foodie.dart';
import 'package:elixir2/pages/register/register_hotel.dart';
import 'package:elixir2/pages/register/register_volunteer.dart';
import 'package:flutter/material.dart';

import '../../themebutton.dart';
import '../welcome_page.dart';

class RegisterHome extends StatefulWidget{
  const RegisterHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<RegisterHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade700,
        leading:
        IconButton( onPressed: (){
          gotoWelcome(context);
        },icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
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
          children: [
            Container(
              height: 200,

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
            const SizedBox(height: 50),
            const Text('Which Account do you wish to create?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(height: 40),
            ThemeButton(
              label: 'Restaurant',
              highlight: Colors.green[900],
              color: Colors.pink,
              onClick: () {
                goToRegisterHotel(context);
              },
            ),
            const SizedBox(height: 40),
            ThemeButton(
              label: 'Volunteers',
              highlight: Colors.green[900],
              color: Colors.pink,
              onClick: () {
                goToRegisterVolunteer(context);
              },
            ),
            const SizedBox(height: 40),
            ThemeButton(
              label: 'Foodies',
              highlight: Colors.green[900],
              color: Colors.pink,
              onClick: () {
                goToRegisterFoodie(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  void goToRegisterHotel(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const RegistrationHotel()),
  );
  void goToRegisterFoodie(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const RegistrationFoodie()),
  );
  void goToRegisterVolunteer(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const RegistrationVolunteer()),
  );
  void gotoWelcome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const WelcomePage()),
  );

}