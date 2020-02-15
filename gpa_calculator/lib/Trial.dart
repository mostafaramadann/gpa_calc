import 'package:flutter/material.dart';
import 'package:gpa_calculator/Calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'Course.dart';

class Trial extends StatefulWidget {
  Trial({Key key}) : super(key: key);

  @override
  _TrialState createState() => _TrialState();
}

class _TrialState extends State<Trial> {
  Row label;
  double gpa = 0.0;
  List<Widget> coursesView = new List<Widget>();
  List<Course> courses = new List<Course>();

  _TrialState() {
    label = Row(children: <Widget>[
      CalculatorState.createLabel('Course', CalculatorState.green),
      CalculatorState.createLabel('Grade', CalculatorState.green),
      CalculatorState.createLabel('Hours', CalculatorState.green)
    ]);
    coursesView.add(label);
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
                var cc = new Course(name: "", grade: 'A', hours: '3');
                courses.add(cc);
                coursesView.add(courseLayout(courses.length - 1));
              });
            },
          )
        ],
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Column(children: coursesView),
              Column(
                children: <Widget>[GPAView("Trial", gpa.toString())],
              ),
            ],
          ),
        ),
      ),
    );
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
                  fontSize: 22,
                )),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Color(CalculatorState.green)),
          ),
        ),
      ],
    );
  }

  Row courseLayout(int j) {
    return Row(
      children: <Widget>[
        Expanded(child: new TextField(controller: courses[j].cname)),
        Expanded(
          child: new DropdownButton<String>(
            hint: new Text("Select Grade"),
            value: courses[j].gradeValue,
            items: CalculatorState.grades.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value, child: new Text(value));
            }).toList(),
            onChanged: (String newGrade) {
              setState(() {
                courses[j].gradeValue = newGrade;
                coursesView[j + 1] = courseLayout(j);
                specialGPA();
              });
            },
          ),
        ),
        Expanded(
          child: new TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: courses[j].cHours),
        ),
      ],
    );
  }

  void specialGPA() {
    double gp = 0;
    var total_ch = 0;
    for (int j = 0; j < courses.length; j++) {
      var ch = int.parse(courses[j].cHours.text);
      total_ch += ch;
      gp += CalculatorState.mapGrade(courses[j].gradeValue) * ch;
      print(courses[j].toString());
    }
    gpa = double.parse((gp / total_ch).toStringAsFixed(2));
    print("Gpa is $gpa");
  }
}

/*   for(int i=0;i<noCourses;i++)
          {
            for(int l=0;l<grades.length;l++)
            {
              ps.add(grades[l]);
              for (int k = i + 1; k < noCourses; k++)
              {
                for (int j = 0; j < grades.length; j++)
                {
                  //Possibility p = new Possibility([], gpa)
                }
              }
            }
          }*/
/*for(int j=0;j<noCourses;j++)
        {
          for (int k = 0; k < grades.length; k++)
          {
            for (int i = j+1; i < noCourses; i++)
            {
              Possibility p = new Possibility([], gpa);
            }
          }
        }*/
