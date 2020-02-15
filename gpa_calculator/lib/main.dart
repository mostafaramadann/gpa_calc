import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpa_calculator/FirebaseDB.dart';
import 'Calculator.dart';
import 'LocalDB.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2bb579),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/images/gpa.jpg',
                    width: 100, height: 100),
              ),
              Expanded(
                child: Text(
                  'GPA Calculator',
                  style: pacificoStyle(),
                ),
              ),
              Expanded(
                child: CupertinoButton(
                    child: Text(
                      'Start',
                      style: pacificoStyle(),
                    ),
                    onPressed: () async {
                      WidgetsFlutterBinding.ensureInitialized();
                      //LocalDB.printPath();
                      LocalDB.createDB();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Calculator()));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle pacificoStyle() {
    return TextStyle(
      fontFamily: 'Pacifico',
      color: Colors.white,
      fontSize: 46,
    );
  }
}
