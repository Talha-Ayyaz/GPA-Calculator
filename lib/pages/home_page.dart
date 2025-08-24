import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/pages/cgpa.dart';
import 'package:gpa_calculator/pages/gpa.dart';

class HomePage extends StatelessWidget {
  final String name;

  const HomePage({Key? key, required this.name}) : super(key: key);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 250,),
            Center(
              child: FadeInDown(
                child: Text(
                  "Hey, $name 👋",
                  style: GoogleFonts.montserrat(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SlideInLeft(delay: Duration(milliseconds: 600),child: Text('Perform your Specified Calculation', style: GoogleFonts.montserrat(color: Colors.white),)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListWheelScrollView(
                    itemExtent: 220,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GPACalculator())),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text('Calculate GPA', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 20),
                              Align(alignment: Alignment.center,child: Text("Grade Point Average (GPA) is the measure of a student’s academic performance in a single semester. It is calculated by dividing the total weighted grade points by the total credit hours taken", style: GoogleFonts.montserrat(color: Colors.white),))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CGPACalculator())),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text('Calculate CGPA', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 20),
                              Align(alignment: Alignment.center,child: Text("Cumulative Grade Point Average (CGPA) is the overall measure of a student’s academic performance across all semesters. It is calculated by dividing the total weighted grade points by the total credit hours completed.", style: GoogleFonts.montserrat(color: Colors.white),))
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
