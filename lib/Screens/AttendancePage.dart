import 'dart:io';
import 'dart:convert';

import 'package:attendance_app/DAL/ExclFile.dart';
import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';

class AttendancePage extends StatefulWidget {
  final String department;
  final String level;
  final String subject;
  final String tableName;

  const AttendancePage(
      {Key? key,
      required this.department,
      required this.level,
      required this.tableName,
      required this.subject})
      : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  TextEditingController controller = TextEditingController();
  late DateTime now;
  bool checkPermission = false;
  Directory? folder;
  Timer? timer;
  List<Student> studentList = <Student>[];
  Set<Student> attendingStudents = Set<Student>();

  @override
  void initState() {
    now = DateTime.now();
    StudentsDB.readStudents(
            tableName: widget.tableName,
            department: widget.department,
            level: widget.level)
        .then((value) => studentList = value);
    getPublicDirectoryPath();
    // prepareStorage();

    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      getClient();
    });
  }

  Future<void> getPublicDirectoryPath() async {
    await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      checkPermission = true;
      Directory folder1 = Directory('/storage/emulated/0/الطلاب الحاضرون');
      if (!folder1.existsSync()) {
        folder1.createSync();
        print(folder1.path);
      }
      Directory folder2 = Directory('/storage/emulated/0/الطلاب الغائبون');
      if (!folder2.existsSync()) {
        folder2.createSync();
        print(folder2.path);
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<List<APClient>> getClientList(
      bool onlyReachables, int reachableTimeout) async {
    List<APClient> htResultClient;

    try {
      // ignore: deprecated_member_use
      htResultClient = await WiFiForIoTPlugin.getClientList(
          onlyReachables, reachableTimeout);
    } on PlatformException {
      htResultClient = <APClient>[];
    }

    return htResultClient;
  }

  void getClient() {
    setState(() {
      getClientList(false, 300).then((val) => val.forEach((oClient) {
            for (int i = 0; i < studentList.length; i++) {
              if (oClient.hwAddr == studentList[i].mac) {
                attendingStudents.add(studentList[i]);
              }
            }
          }));
    });
  }

/*
  getAllDepartement() async {
    departementList = await StudentsDB.readDepartement();

    for (var item in departementList) {
      print(item.name);
      menuItems1.add(item.name);
    }
  }


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


// */
  @override
  Widget build(BuildContext context) {
    print(studentList.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب الحاضرون'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(top: 15, right: 15),
        //     child: Text('الاجمالي: ${attendingStudents.length}'),
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20)),
            //     ),
            //     onPressed: () async {
            //       if (checkPermission) {
            //         timer?.cancel();
            //         String path = '/storage/emulated/0/الطلاب الحاضرون/';
            //         String totle = ExcelFile.createExcelFile(
            //             now,
            //             attendingStudents,
            //             widget.department,
            //             widget.level,
            //             widget.subject,
            //             path);
            //         showDialog<String>(
            //           context: context,
            //           builder: (BuildContext context) => AlertDialog(
            //             backgroundColor: Color(0xff1f2c34),
            //             title: Text(
            //               'اجالي الحاضرون: $totle',
            //               style: TextStyle(color: Colors.white),
            //             ),
            //             content: Text('تم تصدير وحفظ الملف بنجاح',
            //                 style: TextStyle(color: Colors.white),
            //                 textDirection: TextDirection.rtl),
            //             contentPadding: EdgeInsets.all(8.0),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () => Navigator.pop(context),
            //                 child: const Text('موافق'),
            //               ),
            //             ],
            //           ),
            //         );
            //       } else {
            //         getPublicDirectoryPath();
            //       }
            //     },
            //     icon: Icon(Icons.save),
            //     label: Text('تصدير الطلاب الحاضرون في ملف اكسل')),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () async {
                if (checkPermission) {
                  timer?.cancel();
                  String totle = await getAbsentStudent(now);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Color(0xff1f2c34),
                      title: Text(
                        'اجالي الغائبون: $totle',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Text('تم حفظ الطلاب الغائبون بنجاح',
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
                  getPublicDirectoryPath();
                }
              },
              icon: Icon(Icons.save),
              label: Text('حفظ الطلاب الغياب'),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.add),
                  contentPadding: EdgeInsets.only(left: 20),
                  labelText: 'رقم الطالب',
                  hintText: 'ادخل رقم الطالب لتحضيره يدوي ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.blue)),
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                if (controller.text.isEmpty) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Color(0xff1f2c34),
                      content: Text('الرجاء ادخال رقم الطالب اولا',
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
                  bool check = false;
                  for (int i = 0; i < studentList.length; i++) {
                    if (controller.text == studentList[i].studentID) {
                      attendingStudents.add(studentList[i]);
                      check = true;
                    }
                  }
                  if (check) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xff1f2c34),
                        content: Text('تم تحضير الطالب يدويا بنجاح',
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
                    setState(() {});
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xff1f2c34),
                        content: Text('الرجاء ادخال رقم طالب صحيح',
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
                  }
                }
              },
              icon: Icon(Icons.add),
              label: Text('تحضير الطالب يدويا'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' تاريخ الحضور',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'اسم الطالب',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'رقم الطالب',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: attendingStudents.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Center(
                      child: ListTile(
                        leading: Text(
                          '${now.year}.${now.month}.${now.day}',
                          style: TextStyle(fontSize: 16),
                        ),
                        title: Text(
                          attendingStudents.elementAt(index).name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          attendingStudents.elementAt(index).studentID,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getAbsentStudent(DateTime time) async {
    List<String> attendingStuListID = [];
    Set<Student> absentStudents = Set<Student>();
    for (int i = 0; i < attendingStudents.length; i++) {
      attendingStuListID.add(attendingStudents.elementAt(i).studentID);
    }
    for (int i = 0; i < studentList.length; i++) {
      if (attendingStuListID.contains(studentList[i].studentID)) {
      } else {
        absentStudents.add(studentList[i]);
        studentList[i].createdTime = time;
        await StudentsDB.createAbsentStudents(
            Student(
                studentID: studentList[i].studentID,
                name: studentList[i].name,
                level: studentList[i].level,
                department: studentList[i].department,
                mac: studentList[i].mac,
                subject: widget.subject,
                createdTime: studentList[i].createdTime),
            'AbsentStudent');
      }
    }

    return absentStudents.length.toString();
  }
}
