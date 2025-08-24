import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class GPACalculator extends StatefulWidget {
  @override
  _GPACalculatorState createState() => _GPACalculatorState();
}

class _GPACalculatorState extends State<GPACalculator> {
  List<CourseRow> courses = [];
  double semesterGPA = 0.0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      courses.add(CourseRow(courseNumber: i + 1));
    }
  }

  void addCourse() {
    setState(() {
      courses.add(CourseRow(courseNumber: courses.length + 1, isNew: true));
    });
  }

  void clearAll() {
    setState(() {
      for (var course in courses) {
        course.marksController.clear();
        course.creditController.clear();
      }
      semesterGPA = 0.0;
    });
  }

  double gradePointFromMark(int mark) {
    if (mark >= 80) return 4.00;
    if (mark < 40) return 0.00;

    const map = {
      79: 3.94, 78: 3.87, 77: 3.80, 76: 3.74, 75: 3.67, 74: 3.60, 73: 3.54,
      72: 3.47, 71: 3.40, 70: 3.34, 69: 3.27, 68: 3.20, 67: 3.14, 66: 3.07,
      65: 3.00, 64: 2.92, 63: 2.85, 62: 2.78, 61: 2.70, 60: 2.64, 59: 2.57,
      58: 2.50, 57: 2.43, 56: 2.36, 55: 2.30, 54: 2.24, 53: 2.18, 52: 2.12,
      51: 2.06, 50: 2.00, 49: 1.90, 48: 1.80, 47: 1.70, 46: 1.60, 45: 1.50,
      44: 1.40, 43: 1.30, 42: 1.20, 41: 1.10, 40: 1.00
    };

    return map[mark] ?? 0.0;
  }

  void calculateGPA() {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var course in courses) {
      final marks = int.tryParse(course.marksController.text) ?? 0;
      final credits = double.tryParse(course.creditController.text) ?? 0;

      if (credits <= 0) continue;

      final gp = gradePointFromMark(marks);
      totalPoints += gp * credits;
      totalCredits += credits;
    }

    setState(() {
      semesterGPA = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    });
  }

  void removeCourse(int index) {
    setState(() {
      courses.removeAt(index);
      for (int i = 0; i < courses.length; i++) {
        courses[i] = CourseRow(
          courseNumber: i + 1,
          marksController: courses[i].marksController,
          creditController: courses[i].creditController,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
          title: Text("GPA Calculator", style: GoogleFonts.montserrat(),),
          centerTitle: true,
         backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final delay = courses[index].isNew ? 200 : (200 * (index + 1));
                  return CourseRowWrapper(
                    course: courses[index],
                    delay: delay,
                    onRemove: () => removeCourse(index),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Semester GPA: ${semesterGPA.toStringAsFixed(2)}",
              style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white
                    ),
                    onPressed: addCourse,
                    child: Text("Add Course", style: GoogleFonts.montserrat(),)
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white
                    ),
                    onPressed: calculateGPA,
                    child: Text("Calculate", style: GoogleFonts.montserrat(),)
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white
                    ),
                    onPressed: clearAll,
                    child: Text("Clear All", style: GoogleFonts.montserrat(),)
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


class CourseRow {
  final int courseNumber;
  final TextEditingController marksController;
  final TextEditingController creditController;
  final bool isNew;

  CourseRow({
    required this.courseNumber,
    this.isNew = false,
    TextEditingController? marksController,
    TextEditingController? creditController,
  })  : marksController = marksController ?? TextEditingController(),
        creditController = creditController ?? TextEditingController();
}


class CourseRowWrapper extends StatefulWidget {
  final CourseRow course;
  final VoidCallback onRemove;
  final int delay;

  const CourseRowWrapper({
    Key? key,
    required this.course,
    required this.onRemove,
    required this.delay,
  }) : super(key: key);

  @override
  State<CourseRowWrapper> createState() => _CourseRowWrapperState();
}

class _CourseRowWrapperState extends State<CourseRowWrapper> {
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
      child: CourseRowWidget(
        course: widget.course,
        onRemove: _removeWithAnimation,
      ),
    )
        : (widget.course.isNew
        ? FadeInRight(
      duration: Duration(milliseconds: 400),
      delay: Duration(milliseconds: widget.delay),
      child: CourseRowWidget(
        course: widget.course,
        onRemove: _removeWithAnimation,
      ),
    )
        : FadeInUp(
      duration: Duration(milliseconds: 400),
      delay: Duration(milliseconds: widget.delay),
      child: CourseRowWidget(
        course: widget.course,
        onRemove: _removeWithAnimation,
      ),
    ));
  }
}


class CourseRowWidget extends StatelessWidget {
  final CourseRow course;
  final VoidCallback onRemove;

  const CourseRowWidget({
    Key? key,
    required this.course,
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
              Text("Course ${course.courseNumber}",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.close), onPressed: onRemove),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: course.marksController,
                  decoration: InputDecoration(
                    labelText: "Marks",
                    labelStyle: GoogleFonts.montserrat(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1), // normal
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2), // when clicked
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: course.creditController,
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
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
