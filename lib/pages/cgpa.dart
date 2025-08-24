import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/pages/review.dart';

class CGPACalculator extends StatefulWidget {
  @override
  _CGPACalculatorState createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  List<SemesterRow> semesters = [];
  double cgpa = 0.0;

  @override
  void initState() {
    super.initState();
    // Start with only 1 semester row
    semesters.add(SemesterRow(semesterNumber: 1));
  }

  void addSemester() {
    if (semesters.length < 8) {
      setState(() {
        semesters.add(SemesterRow(
          semesterNumber: semesters.length + 1,
          isNew: true,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only add up to 8 semesters")),
      );
    }
  }

  void clearAll() {
    setState(() {
      for (var semester in semesters) {
        semester.gpaController.clear();
        semester.creditController.clear();
      }
      cgpa = 0.0;
    });
  }

  void calculateCGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var semester in semesters) {
      final gpa = double.tryParse(semester.gpaController.text) ?? 0.0;
      final credits = double.tryParse(semester.creditController.text) ?? 0.0;

      if (credits <= 0) continue;

      totalPoints += gpa * credits;
      totalCredits += credits;
    }

    double finalCgpa = totalCredits > 0 ? totalPoints / totalCredits : 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewPage(cgpa: finalCgpa),
      ),
    );
  }


  void removeSemester(int index) {
    setState(() {
      semesters.removeAt(index);
      // Re-index semester numbers
      for (int i = 0; i < semesters.length; i++) {
        semesters[i] = SemesterRow(
          semesterNumber: i + 1,
          gpaController: semesters[i].gpaController,
          creditController: semesters[i].creditController,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
          title: Text("CGPA Calculator", style: GoogleFonts.montserrat(),),
          centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: semesters.length,
                itemBuilder: (context, index) {
                  final delay = semesters[index].isNew ? 200 : (200 * (index + 1));
                  return SemesterRowWrapper(
                    semester: semesters[index],
                    delay: delay,
                    onRemove: () => removeSemester(index),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              "CGPA: ${cgpa.toStringAsFixed(2)}",
              style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: addSemester,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white
                  ),
                  child: Text("Add Sem", style: GoogleFonts.montserrat(),),
                ),

                ElevatedButton(
                  onPressed: calculateCGPA,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white
                  ),
                  child: Text("Calculate", style: GoogleFonts.montserrat(),),
                ),
                ElevatedButton(
                  onPressed: clearAll,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white
                  ),
                  child: Text("Clear All", style: GoogleFonts.montserrat(),),
                ),
              ],
            ),
            const SizedBox(height: 15,)
          ],
        ),
      ),
    );
  }
}

/// Data model
class SemesterRow {
  final int semesterNumber;
  final TextEditingController gpaController;
  final TextEditingController creditController;
  final bool isNew;

  SemesterRow({
    required this.semesterNumber,
    this.isNew = false,
    TextEditingController? gpaController,
    TextEditingController? creditController,
  })  : gpaController = gpaController ?? TextEditingController(),
        creditController = creditController ?? TextEditingController();
}


class SemesterRowWrapper extends StatefulWidget {
  final SemesterRow semester;
  final VoidCallback onRemove;
  final int delay;

  const SemesterRowWrapper({
    Key? key,
    required this.semester,
    required this.onRemove,
    required this.delay,
  }) : super(key: key);

  @override
  State<SemesterRowWrapper> createState() => _SemesterRowWrapperState();
}

class _SemesterRowWrapperState extends State<SemesterRowWrapper> {
  bool _isRemoved = false;

  void _removeWithAnimation() {
    setState(() => _isRemoved = true);
    Future.delayed(Duration(milliseconds: 400), () {
      widget.onRemove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isRemoved
        ? FadeOutLeft(
      duration: Duration(milliseconds: 400),
      child: SemesterRowWidget(
        semester: widget.semester,
        onRemove: _removeWithAnimation,
      ),
    )
        : (widget.semester.isNew
        ? FadeInRight(
      duration: Duration(milliseconds: 400),
      delay: Duration(milliseconds: widget.delay),
      child: SemesterRowWidget(
        semester: widget.semester,
        onRemove: _removeWithAnimation,
      ),
    )
        : FadeInUp(
      duration: Duration(milliseconds: 400),
      delay: Duration(milliseconds: widget.delay),
      child: SemesterRowWidget(
        semester: widget.semester,
        onRemove: _removeWithAnimation,
      ),
    ));
  }
}


class SemesterRowWidget extends StatelessWidget {
  final SemesterRow semester;
  final VoidCallback onRemove;

  const SemesterRowWidget({
    Key? key,
    required this.semester,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Semester ${semester.semesterNumber}",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.close), onPressed: onRemove),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: semester.gpaController,
                  decoration: InputDecoration(
                    labelText: "GPA",
                    labelStyle: GoogleFonts.montserrat(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1), // normal
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2), // when clicked
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: semester.creditController,
                  decoration: InputDecoration(
                    labelText: "Credits",
                    labelStyle: GoogleFonts.montserrat(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1), // normal
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2), // when clicked
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
