import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Course.dart';
import 'Semester.dart';

class LocalDB {
  static String _courseTable = 'Course';
  static String columnCourseName = 'Course_Name';
  static String columnCourseId = 'cid';
  static String columnCourseGrade = 'Course_Grade';
  static String columnCreditHours = 'Credit_Hour';
  static String columnCourseForeignLinkedToSem = 'SemesterFK';
  static String _semesterTable = 'Semester';
  static String columnSemesterId = 'sid';
  static String columnSemesterName = 'Semester_Name';
  static String columnSemesterGPA = 'Semester_GPA';
  static var _path;
  static Database _database;
  static void printPath() async {
    // _path = await getDatabasesPath();
    // _path = join(_path, 'calculator.db');
    // print(_path);
  }

  static void createDB() async {
    await deleteDatabase(join(await getDatabasesPath(), 'Calculator.db'));
    _database = await openDatabase(
        join(await getDatabasesPath(), 'Calculator.db'),
        version: 1, onCreate: (Database db, int version) async {
      db.execute('CREATE TABLE $_semesterTable ('
          '$columnSemesterId INTEGER PRIMARY KEY AUTOINCREMENT,'
          '$columnSemesterName TEXT,'
          '$columnSemesterGPA REAL)');
      db.execute('CREATE TABLE $_courseTable ('
          '$columnCourseId INTEGER PRIMARY KEY AUTOINCREMENT,'
          '$columnCourseName TEXT,'
          '$columnCourseGrade TEXT,'
          '$columnCreditHours TEXT,'
          '$columnCourseForeignLinkedToSem INTEGER,'
          'FOREIGN KEY ($columnCourseForeignLinkedToSem) REFERENCES $_semesterTable($columnSemesterId))');
    });
  }

  static Future<void> printCourses() async {
    if (_database != null) {
      final Database db = _database;
      final List<Map<String, dynamic>> maps =
          await db.query(LocalDB._courseTable);
      print("PRINTING COURSES");
      List.generate(maps.length, (i) {
        print(maps[i].toString());
        return Course(
          grade: maps[i][columnCourseGrade],
          name: maps[i][columnCourseName],
          hours: maps[i][columnCreditHours],
        );
      });
    }
  }

  static Future<void> insertSemester(Semester s, List<Course> courses) async {
    if (_database != null) {
      final Database db = _database;
      var id = await db.insert(LocalDB._semesterTable, s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(id.toString());
      for (int i = s.startIndex; i <= s.endIndex; i++) {
        await insertCourse(courses[i], id);
      }
    }
  }

  static Future<void> insertCourse(Course c, int semId) async {
    if (_database != null) {
      final Database db = _database;
      await db.insert(LocalDB._courseTable, c.toMap(semId),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
