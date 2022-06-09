// ignore: file_names

//import 'package:elixir2/pages/payment/payment.dart';
import 'package:elixir2/pages/welcome_page.dart';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';




class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'About Us',
          body: 'Help food reach needy people,volunteer and earn credits,explore amazing food posts and blogs, all in one place',
          image: buildImage('assets/ELIXIR_logo.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Features',
          body: 'Explore new restaturants, create your own food blog and be your food experty',
          image: buildImage('assets/ELIXIR_logo.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Welcome',
          body: 'On board with us to reach the goal of zero hunger',
          image: buildImage('assets/ELIXIR_logo.png'),
          decoration: getPageDecoration(),
        ),

      ],
     done: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToWelcomePage(context),
      showSkipButton: true,
      skip: const Text('Skip'),
      onSkip: () => goToWelcomePage(context),
      next: const Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToWelcomePage(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => WelcomePage()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: const Color(0xFF0097A7),
    //activeColor: Colors.orange,
    size: const Size(10, 10),
    activeSize: const Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
    bodyTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
    descriptionPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: const EdgeInsets.all(24),
    pageColor: Colors.cyan.shade700,
  );
}