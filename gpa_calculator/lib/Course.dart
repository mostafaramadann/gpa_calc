import 'package:flutter/material.dart';
import 'Calculator.dart';
import 'package:flutter/services.dart';
class Course {
  TextEditingController _cname;
  TextEditingController _cHours;
  String gradeValue = "-";
  Course({String name, String grade, String hours}) {
    this._cname = new TextEditingController();
    this._cHours = new TextEditingController();
    _cname.text = name;
    _cHours.text = hours;
    gradeValue = grade;
  }

  @override
  String toString() {
    return 'Course{_cname:' + _cname.text + '_cHours:' + _cHours.text + 'gradeValue: $gradeValue}';
  }

  TextEditingController get cHours => _cHours;
  TextEditingController get cname => _cname;
}
