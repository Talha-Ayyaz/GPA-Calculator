import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class NameInputPage extends StatefulWidget {
  @override
  _NameInputPageState createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController nameController = TextEditingController();

  void saveName() async {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", name);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(name: name)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey.shade300], // grey → silver
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please Enter your Name So That\n We can Address you Properly', style: GoogleFonts.montserrat(color: Colors.white),),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  labelStyle: GoogleFonts.montserrat(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1), // normal
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2), // when clicked
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveName,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white
                ),
                child: Text("Save", style: GoogleFonts.montserrat(),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
