import 'package:attendance_app/AppUI.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WellCome() //AppUI(),
        );
  }
}

class WellCome extends StatelessWidget {
  const WellCome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                'أهلا بك في',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 150,
                height: 150,
              ),
            ),
            Text(
              'نظام تسجيل حضور الطلاب الكترونيا',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'مشروع مقدم الى قسم تقنية المعلومات كأحد متطلبات نيل درجة البكالوريوس',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => AppUI()));
                },
                child: Text(
                  'الشاشة الرئيسية',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
