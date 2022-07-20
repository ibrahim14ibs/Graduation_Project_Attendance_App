import 'dart:async';

import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/departement.dart';
import 'package:attendance_app/Models/subject.dart';
import 'package:attendance_app/Screens/AddDepartement.dart';
import 'package:attendance_app/Screens/AddSubject.dart';
import 'package:attendance_app/Screens/AttendancePage.dart';
import 'package:attendance_app/Screens/ViewAbsentStudent.dart';
import 'package:attendance_app/Screens/ViewStudents.dart';
import 'package:flutter/material.dart';

class AppUI extends StatefulWidget {
  const AppUI({Key? key}) : super(key: key);

  @override
  State<AppUI> createState() => _AppUIState();
}

class _AppUIState extends State<AppUI> {
  // Set<Departement> departementSet = Set();
  // static final menuItems1 = <String>[];
  // final List<DropdownMenuItem<String>> dropdownMenuItem1 = menuItems1
  //     .map(
  //       (String value) => DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       ),
  //     )
  //     .toList();

  static final menuItems2 = <String>[
    '1',
    '2',
    '3',
    '4',
  ];

  final List<DropdownMenuItem<String>> dropdownMenuItem2 = menuItems2
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String? departement = 'IT';
  Set<String> departementName = Set();
  String? subject;
  Set<String> subjectName = Set();

  String level = '4';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الشاشة الرئيسية'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: ListView(
            children: [
              ListTile(
                title: FutureBuilder<List<Departement>>(
                    future: StudentsDB.readDepartement(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Departement>> snapshot) {
                      if (!snapshot.hasData)
                        return CircularProgressIndicator();
                      else {
                        for (var item in snapshot.data!) {
                          departementName.add(item.name);
                        }
                        return DropdownButton<String>(
                          value: departement,
                          onChanged: (String? newValue) {
                            setState(() {
                              departement = newValue!;
                            });
                          },
                          hint: Text('اختر تخصص'),
                          items: departementName.map((departements) {
                            // Set<String> items = Set();
                            // items.add(departements.name);
                            // print(items);
                            return DropdownMenuItem<String>(
                              child: Text(departements),
                              value: departements,
                            );
                          }).toList(),
                        );
                      }
                    }),
                trailing: Text(
                  'الرجاء اختيارالتخصص',
                  style: TextStyle(fontSize: 17),
                ),
              ),

              ListTile(
                title: DropdownButton<String>(
                  value: level,
                  onChanged: (String? newValue) {
                    setState(() {
                      level = newValue!;
                    });
                  },
                  items: this.dropdownMenuItem2,
                ),
                trailing: Text(
                  'الرجاء اختيار المستوى',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              ListTile(
                title: FutureBuilder<List<Subject>>(
                    future: StudentsDB.readSubject(
                        departement: departement!, level: level),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Subject>> snapshot) {
                      if (!snapshot.hasData)
                        return CircularProgressIndicator();
                      else {
                        subjectName.clear();

                        for (var item in snapshot.data!) {
                          subjectName.add(item.name);
                        }
                        return DropdownButton<String>(
                          value: subject,
                          onChanged: (String? newValue) {
                            setState(() {
                              subject = newValue!;
                            });
                          },
                          hint: Text('اختر مقرر'),
                          items: subjectName.map((subjects) {
                            // Set<String> items = Set();
                            // items.add(departements.name);
                            // print(items);
                            return DropdownMenuItem<String>(
                              child: Text(subjects),
                              value: subjects,
                            );
                          }).toList(),
                        );
                      }
                    }),
                trailing: Text(
                  'الرجاء اختيار المقرر',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              // ListTile(
              //   title: DropdownButton<String>(
              //     value: subject,
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         subject = newValue!;
              //       });
              //     },
              //     items: this.dropdownMenuItem3,
              //   ),
              //   trailing: Text(
              //     'الرجاء اختيار المقرر',
              //     style: TextStyle(fontSize: 17),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ViewStudents(
                              department: departement!,
                              level: level,
                              tableName: 'student')));
                    },
                    child: Text(
                      'عرض الطلاب',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (subject == null || departement == null) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Color(0xff1f2c34),
                            content: Text(
                                'الرجاء اختيار كلا من المقرر والتخصص ',
                                style: TextStyle(color: Colors.white),
                                textDirection: TextDirection.rtl),
                            contentPadding: EdgeInsets.all(8.0),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('موافق'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ViewAbsentStudent(
                                department: departement!,
                                level: level,
                                subject: subject!,
                                tableName: 'AbsentStudent')));
                      }
                    },
                    child: Text(
                      'عرض الطلاب الغياب',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (subject == null || departement == null) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Color(0xff1f2c34),
                            content: Text(
                                'الرجاء اختيار كلا من المقرر والتخصص ',
                                style: TextStyle(color: Colors.white),
                                textDirection: TextDirection.rtl),
                            contentPadding: EdgeInsets.all(8.0),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('موافق'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AttendancePage(
                                department: departement!,
                                level: level,
                                subject: subject!,
                                tableName: 'student')));
                      }
                    },
                    child: Text(
                      'تسجيل حضور الطلاب',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    )),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      final refresh = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddDepartement()));

                      if (refresh == true || refresh == null) {
                        setState(() {});
                      }
                    },
                    child: Text(
                      'اضافة تخصص',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    )),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      final refresh = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddSubject()));

                      if (refresh == true || refresh == null) {
                        setState(() {});
                      }
                    },
                    child: Text(
                      'اضافة مقرر',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
