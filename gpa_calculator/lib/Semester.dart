import 'LocalDB.dart';

class Semester {
  String sName = '__';
  double gpa = 0.0;
  int startIndex = 0;
  int endIndex = 0;

  Semester();

  Map<String, dynamic> toMap() {
    return {LocalDB.columnSemesterName: sName, LocalDB.columnSemesterGPA: gpa};
  }
  /*Semester.fromMap(Map<String, dynamic> map) {
    _cname.text = map[LocalDB.columnCourseName];
    gradeValue = map[LocalDB.columnCourseGrade];
    _cHours = map[LocalDB.columnCreditHours];
    semId = map[LocalDB.columnCourseForeignLinkedToSem];
  }*/
}
