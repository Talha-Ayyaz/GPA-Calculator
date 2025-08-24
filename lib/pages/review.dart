import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewPage extends StatelessWidget {
  final double cgpa;

  ReviewPage({required this.cgpa});

  String getReview() {
    if (cgpa >= 3.5) {
      return "Excellent 🌟 (Outstanding performance)";
    } else if (cgpa >= 3.0) {
      return "Very Good ✅ (Above average)";
    } else if (cgpa >= 2.5) {
      return "Good 👍 (Satisfactory)";
    } else if (cgpa >= 2.0) {
      return "Fair ⚠️ (Needs improvement)";
    } else {
      return "Poor ❌ (At risk, must improve)";
    }
  }

  String getMotivation() {
    if (cgpa >= 3.5) {
      return "Outstanding! Keep it up 🎉";
    } else if (cgpa >= 3.0) {
      return "Great job, aim for excellence 🚀";
    } else if (cgpa >= 2.5) {
      return "Good work, you can push higher 💪";
    } else if (cgpa >= 2.0) {
      return "Stay focused and keep improving 📚";
    } else {
      return "Don’t give up, work harder and bounce back 🔥";
    }
  }

  Color getReviewColor() {
    if (cgpa >= 3.5) return Colors.green;
    if (cgpa >= 3.0) return Colors.lightGreen;
    if (cgpa >= 2.5) return Colors.orange;
    if (cgpa >= 2.0) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title: Text("CGPA Review", style: GoogleFonts.montserrat(),),
        centerTitle: true,
        backgroundColor: getReviewColor(),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: getReviewColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: getReviewColor(), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your CGPA",
                style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                cgpa.toStringAsFixed(2), // 👈 show 2 decimal places
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: getReviewColor(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                getReview(),
                style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Text(
                getMotivation(),
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
