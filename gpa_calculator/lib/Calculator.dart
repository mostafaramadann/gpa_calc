import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Course.dart';
import 'Semester.dart';
class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  int green = 0xff2bb579;
  Row label;
  int i=0;
  static final List<String> grades = ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F'];
  List<Semester> semesters = new List<Semester>();
  List<Widget> coursesView = new List<Widget>();
  List<Course> courses = new List<Course>();
  Semester sem = new Semester();
  CalculatorState() {
    label = Row(children: <Widget>[createLabel('Course'),createLabel('Grade'),createLabel('Hours')]);
    //coursesView.add(label);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          persistentFooterButtons: <Widget>[
            CupertinoButton(
              child: Text("Course"),
              onPressed: (){
                setState(() {
                  //if(coursesView.isNotEmpty) {
                    var cc = new Course(name: "", grade: 'A', hours: '3');
                    courses.add(cc);
                    sem.endIndex=courses.length-1;
                    coursesView.add(courseLayout(courses.length-1));
                 // }
                });
              },
            ),
            CupertinoButton(
              child: Text("Semester"),
              onPressed:()
              {
                setState(() {
                  if (coursesView.last!=label) {
                    sem.sName='Sem $i';
                    semesters.add(sem);
                    sem = new Semester();
                    //coursesView.add(label);
                    i++;
                  }
                });
              },
            ),
            CupertinoButton(
              child: Text('Results'),
              onPressed: ()
              {
                if(semesters.isNotEmpty) {
                  if (semesters.last.endIndex != sem.endIndex) {
                    sem.sName = 'Sem $i';
                    semesters.add(sem);
                    sem = new Semester();
                    i++;
                  }
                }
                var start=0;
               var cumulative_gpa=0;
                for(int i = 0 ; i<semesters.length;i++)
                  {
                    double gp=0;
                    int total_ch=0;
                    print("Semester name : "+semesters[i].sName);
                    for(int j=start;j<=semesters[i].endIndex;j++)
                      {
                        var ch = int.parse(courses[j].cHours.text);
                        total_ch+=ch;
                        gp += mapGrade(courses[j].gradeValue)*ch;
                        print(courses[j].toString());
                      }
                    semesters[i].gpa=double.parse((gp/total_ch).toStringAsFixed(2));
                    print("Semester Gpa is " + semesters[i].gpa.toString());
                    start=semesters[i].endIndex+1;
                  }
              },
            )
          ],
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                Column(
                  children:coursesView,
                )
              ],//semesterView
            ),
          )
      ),
    );
  }
  /*Column semlayout(List<Row> s)
  {
    return Column(children:s);
  }*/
  Row courseLayout(int j) {
    return Row(
      children: <Widget>[
        Expanded(
            child: new TextField(controller: courses[j].cname)),
        Expanded(
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
                coursesView[j] = courseLayout(j);
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
  Expanded createLabel(String string) {
    return new Expanded(
        child: Text('$string',
            style: TextStyle(
              fontFamily: 'Pacifico',
              color: Color(green),
              fontSize: 22,
            )));
  }
  double mapGrade(String g)
  {
    Map<String, double> gmap = {
      'A': 4,
      'A-': 3.67,
      'B+': 3.33333333,
      'B':3,
      'B-':2.67,
      'C+':2.33333333,
      'C' :2,
      'C-':1.67,
      'D+':1.33,
      'D':1,
      'F':0
    };
    if (gmap.containsKey(g))
      return gmap[g];
  }
//course name , Grade ,credit hours

}
