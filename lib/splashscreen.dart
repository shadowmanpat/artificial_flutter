import 'package:artificial_flutter/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(seconds: 2,
    navigateAfterSeconds: MyHome(),
      title: const Text("Cat dog clasifier", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),),
      image: Image.asset('assets/cat_dog_icon.png'),
      backgroundColor: Colors.blue,
      photoSize: 60,
      loaderColor: Colors.grey,
    );
  }
}
