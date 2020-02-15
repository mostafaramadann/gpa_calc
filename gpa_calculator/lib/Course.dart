import 'package:flutter/material.dart';
import 'LocalDB.dart';

class Course {
  TextEditingController _cname;
  TextEditingController _cHours;
  int semId = 0;
  String gradeValue = "-";

  Course({String name, String grade, String hours}) {
    this._cname = new TextEditingController();
    this._cHours = new TextEditingController();
    _cname.text = name;
    _cHours.text = hours;
    gradeValue = grade;
  }

  TextEditingController get cHours => _cHours;

  TextEditingController get cname => _cname;

  @override
  String toString() {
    return 'Course{_cname:' +
        _cname.text +
        '_cHours:' +
        _cHours.text +
        'gradeValue: $gradeValue}';
  }

  Map<String, dynamic> toMap(int semId) {
    //this.semId = semId;
    return {
      //LocalDB.columnCourseId: id,
      LocalDB.columnCourseName: _cname.text,
      LocalDB.columnCourseGrade: gradeValue,
      LocalDB.columnCreditHours: _cHours.text,
      LocalDB.columnCourseForeignLinkedToSem: semId
    };
  }

  Course.fromMap(Map<String, dynamic> map) {
    _cname.text = map[LocalDB.columnCourseName];
    gradeValue = map[LocalDB.columnCourseGrade];
    _cHours.text = map[LocalDB.columnCreditHours];
    semId = map[LocalDB.columnCourseForeignLinkedToSem];
  }
}
