import 'package:cloud_firestore/cloud_firestore.dart';
import 'Semester.dart';
import 'Course.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDB {
  static int _sem = 0;
  static final _firestore = Firestore.instance;
  static final auth = FirebaseAuth.instance;
  static void connect() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: "Abcddd@gmail.com", password: "DEFghef");
      await auth.signInWithEmailAndPassword(
          email: "Abcddd@gmail.com", password: "DEFghef");
    } catch (e) {
      print(e);
    }
  }

  static void insertSemester(Semester s, List<Course> courses) async {
    await _firestore.collection('Semester').add(s.toMap());
    for (int i = s.startIndex; i <= s.endIndex; i++) {
      await insertCourse(courses[i], _sem);
    }
    _sem += 1;
  }

  static void insertCourse(Course c, int semid) async {
    await _firestore.collection('Course').add(c.toMap(semid));
  }
}
