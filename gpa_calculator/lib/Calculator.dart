import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/FirebaseDB.dart';
import 'package:gpa_calculator/Trial.dart';
import 'dart:collection';
import 'Course.dart';
import 'Semester.dart';
import 'LocalDB.dart';
import 'Possibility.dart';

class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  static final List<String> grades = [
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'F'
  ];
  static int green = 0xff2bb579;
  Row label;
  int sem_courses = 0;
  int i = 0;
  List<Semester> semesters = new List<Semester>();
  List<Widget> coursesView = new List<Widget>();
  List<Course> courses = new List<Course>();
  List<Widget> gpaView = new List<Widget>();
  bool lastIsSem = false;
  Semester sem = new Semester();
  double gpacondition = 0.0;
  int noCourses = 0;
  TextEditingController tflabel = TextEditingController();
  TextEditingController tflabel2 = TextEditingController();
  Queue<Possibility> start = new Queue<Possibility>();
  List<Possibility> copy = new List<Possibility>();
  List<Possibility> winning = new List<Possibility>();
  double cum_gp = 0;
  int cum_ch = 0;
  CalculatorState() {
    label = Row(children: <Widget>[
      createLabel('Course', CalculatorState.green),
      createLabel('Grade', CalculatorState.green),
      createLabel('Hours', CalculatorState.green)
    ]);
    semesters.add(sem);
    gpaView.add(GPAView(sem.sName, sem.gpa.toString()));
    gpaView.add(GPAView("Cumulative GPA", "0.0"));
    FirebaseDB.connect();
    tflabel.text = "GPA condition>=";
    tflabel2.text = "Number of Courses";
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          persistentFooterButtons: <Widget>[
            CupertinoButton(
              child: Text("Course"),
              onPressed: () {
                setState(() {
                  if (sem_courses < 6) {
                    var cc = new Course(name: "", grade: 'A', hours: '3');
                    courses.add(cc);
                    sem.endIndex = courses.length - 1;
                    bool header = false;
                    header = sem_courses == 0 ? true : false;
                    coursesView.add(courseLayout(
                        semesters.length - 1, header, courses.length - 1));
                    sem_courses += 1;
                    lastIsSem = false;
                    calculate_gpa();
                  }
                });
              },
            ),
            CupertinoButton(
              child: Text("Semester"),
              onPressed: () {
                setState(() {
                  if (!lastIsSem) {
                    sem.sName = 'Sem $i';
                    LocalDB.insertSemester(sem, courses);
                    FirebaseDB.insertSemester(sem, courses);
                    sem = new Semester();
                    semesters.add(sem);
                    sem.startIndex = semesters.last.endIndex + 1;
                    sem_courses = 0;
                    lastIsSem = true;
                    gpaView.add(GPAView(sem.sName, sem.gpa.toString()));
                    LocalDB.printCourses();
                    i++;
                  }
                });
              },
            ),
            CupertinoButton(
              child: Text("Trial"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Trial()));
              },
            )
          ],
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: ListView(
                children: <Widget>[
                  Column(children: coursesView),
                  Column(children: gpaView),
                  Column(
                    children: <Widget>[
                      ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          Center(
                            child: TextField(
                                onTap: () {
                                  tflabel2.text = "";
                                },
                                controller: tflabel2,
                                onChanged: (value) {
                                  if (value.isNotEmpty)
                                    noCourses = int.parse(value);
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ]),
                          ),
                          Center(
                            child: TextField(
                              onTap: () {
                                tflabel.text = "";
                              },
                              controller: tflabel,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value.isNotEmpty)
                                  gpacondition = double.parse(value);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                          child: CupertinoButton(
                        child: Text(
                          'Suggest Minimum',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          GeneratePossibilities();
                        },
                      ))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget courseLayout(int i, bool header, int j) {
    List<Widget> cLayout = new List<Widget>();
    cLayout.add(Expanded(child: new TextField(controller: courses[j].cname)));
    cLayout.add(Expanded(
        child: new DropdownButton<String>(
            hint: new Text("Select Grade"),
            value: courses[j].gradeValue,
            items: grades.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value, child: new Text(value));
            }).toList(),
            onChanged: (String newGrade) {
              setState(() {
                courses[j].gradeValue = newGrade;
                calculate_gpa();
                coursesView[j] = courseLayout(i, header, j);
              });
            })));
    cLayout.add(Expanded(
        child: new TextField(
            onChanged: (String value) {
              setState(() {
                calculate_gpa();
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            controller: courses[j].cHours)));
    List<Widget> children = new List<Widget>();
    if (header) children.add(label);
    children.add(Row(children: cLayout));
    return ListView(
        physics: ClampingScrollPhysics(), shrinkWrap: true, children: children);
  }

  static Expanded createLabel(String string, int color) {
    return new Expanded(
        child: Text(string,
            style: TextStyle(
              fontFamily: 'Pacifico',
              color: Color(color),
              fontSize: 22,
            )));
  }

  static double mapGrade(String g) {
    Map<String, double> gmap = {
      'A': 4,
      'A-': 3.67,
      'B+': 3.33333333,
      'B': 3,
      'B-': 2.67,
      'C+': 2.33333333,
      'C': 2,
      'C-': 1.67,
      'D+': 1.33,
      'D': 1,
      'F': 0
    };
    if (gmap.containsKey(g)) return gmap[g];
  }

  Widget GPAView(String semName, String gpa) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Center(child: Text(semName)),
        Center(
          child: Container(
            child: Text(gpa,
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Color(0x0ffffffff),
                  fontSize: 22,
                )),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Color(CalculatorState.green)),
          ),
        ),
      ],
    );
  }

  void calculate_gpa() {
    sem.sName = 'Sem $i';
    var start = 0;
    cum_ch = 0;
    cum_gp = 0;
    double gp = 0;
    var total_ch = 0;
    for (int i = 0; i < semesters.length; i++) {
      gp = 0;
      total_ch = 0;
      //print("Semester name : " + semesters[i].sName);
      for (int j = start; j <= semesters[i].endIndex; j++) {
        var ch = int.parse(courses[j].cHours.text);
        total_ch += ch;
        gp += mapGrade(courses[j].gradeValue) * ch;
        //print(courses[j].toString());
      }
      semesters[i].gpa = double.parse((gp / total_ch).toStringAsFixed(2));
      // print("Semester Gpa is " + semesters[i].gpa.toString());
      start = semesters[i].endIndex + 1;
      cum_gp += gp;
      cum_ch += total_ch;
      gpaView[i] = GPAView(semesters[i].sName, semesters[i].gpa.toString());
    }
    var gpa = double.parse((cum_gp / cum_ch).toStringAsFixed(2));
    gpaView.last = GPAView("Cumulative GPA", gpa.toString());
    //print("Your Cumulative GPA is $gpa");
  }

  void GeneratePossibilities() {
    start = new Queue<Possibility>();
    copy = new List<Possibility>();
    winning = new List<Possibility>();
    List<String> ps = new List<String>();
    if (noCourses <= 6 &&
        noCourses != 0 &&
        gpacondition != 0.0 &&
        gpacondition <= 4) {
      for (int i = 0; i < noCourses; i++) {
        ps.add('A');
      }
      Possibility p = new Possibility(ps, 4.0);
      if (isPossible(p.grades) != null) {
        start.addLast(p);
        while (start.length != 0) {
          for (int i = 0; i < noCourses; i++) {
            if (start.length > 0) filter(start.removeLast(), i);
          }
        }
      }
    }
  }

  void filter(Possibility p, i) {
    bool incopy = false;
    List<String> copyy = new List<String>();
    for (int j = i; j < noCourses; j++) {
      for (int k = 0; k < grades.length; k++) {
        copyy = new List<String>();
        copyy.addAll(p.grades);
        copyy[j] = grades[k];
        incopy = false;
        for (int z = 0; z < copy.length; z++) {
          int e = 0;
          while (copy[z].grades[e] == copyy[e]) {
            e++;
            if (e == copy[z].grades.length) break;
          }
          if (e == copy[z].grades.length) {
            incopy = true;
            break;
          }
        }
        if (!incopy) {
          var p2 = isPossible(copyy);
          if (p2 != null) {
            print("Grades :" + p2.grades.toString());
            print("GPA :" + p2.gpa.toString());
            winning.add(p2);
            start.addLast(p2);
            copy.add(p2);
          }
        }
      }
    }
  }

  Possibility isPossible(List<String> copyy) {
    double gp = 0;
    var total_ch = 0;
    for (int j = 0; j < copyy.length; j++) {
      //  var ch = int.parse(courses[j].cHours.text);
      total_ch += 3;
      gp += CalculatorState.mapGrade(copyy[j]) * 3;
      // credit hours hard coded // momken tt3ml le kol course ch
      //bs mkasel
    }
    calculate_gpa();
    cum_gp += gp;
    cum_ch += total_ch;
    var predictedgpa = double.parse((cum_gp / cum_ch).toStringAsFixed(2));
    if (predictedgpa >= gpacondition) return Possibility(copyy, predictedgpa);
    return null;
  }
}

/* Center(
  child: Container(
  child: createLabel(
  semesters[semesters.length - 1].gpa.toString(),
  0x0ffffffff),
  decoration: BoxDecoration(
  shape: BoxShape.circle,
  color: Color(CalculatorState.green)),
  ),
  )*/
//course name , Grade ,credit hours
