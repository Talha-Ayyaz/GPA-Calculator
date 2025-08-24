import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'name_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => checkUserName());
  }

  void checkUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString("username");

    if (savedName == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NameInputPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(name: savedName)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 220,),
            BounceIn(
              delay: Duration(milliseconds: 500),
                child: Icon(Icons.calculate_outlined, size: 200)
            ),
            SizedBox(height: 50),
            Text(
              "GPA/CGPA Calculator",
              style: GoogleFonts.montserrat(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text: 'Created By ', style: GoogleFonts.abhayaLibre(color: Colors.black, fontSize: 20)),
                      TextSpan(text: 'Talha Ayyaz', style: GoogleFonts.chakraPetch(color: Colors.black, fontSize: 20))
                    ]
                )
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
