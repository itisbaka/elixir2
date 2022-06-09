import 'package:elixir2/pages/Onboarding_page.dart';
import 'package:elixir2/pages/login_page.dart';
import 'package:elixir2/pages/register/register_home.dart';
import 'package:elixir2/themebutton.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget{
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade700,
        leading:
        IconButton( onPressed: (){
          gotoOnboardingpage(context);
        },icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
      ),
        body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                        'assets/Background.jpg', fit: BoxFit.cover),
                  ),
                ),
                Center(
                    child:Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child:ClipOval(
                            child: Container(
                              width:180,
                              height:180,
                              alignment: Alignment.topCenter,
                              child: Image.asset('assets/ELIXIR_logo.png',),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ThemeButton(
                          label: 'Register',
                          highlight: Colors.green[900],
                          color: Colors.pink,
                          onClick: () {
                            goToRegister(context);
                          },
                        ),
                        const SizedBox(height: 40),
                        ThemeButton(
                          label: 'Login',
                          highlight: Colors.green[900],
                          color: Colors.pink,
                          onClick: () {
                            goToLogin(context);
                          },
                        ),
                      ],
                    )
                ),
              ],
            )
        )

    );
  }

  void gotoOnboardingpage(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const OnBoardingPage()),
  );

  void goToRegister(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const RegisterHome()),
  );

  void goToLogin(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const LoginPage()),
  );
}