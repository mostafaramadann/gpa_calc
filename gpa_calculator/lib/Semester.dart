import 'package:flutter/material.dart';
import 'Course.dart';
class Semester
{
  String sName='__';
  double gpa=0.0;
  int endIndex=0;
  Semester();
  /*Semester(String name,int endIndex)
  {
    this.sName=name;
    this.endIndex=endIndex;
  }*/
  /*Container semesterLayout()
  {
    for (int i=1;i<coursesView.length;i++ )
      {
        coursesView[i]=courses[i-1].courseLayout();
      }
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: coursesView
        ),
      ),
    );
  }*/
}