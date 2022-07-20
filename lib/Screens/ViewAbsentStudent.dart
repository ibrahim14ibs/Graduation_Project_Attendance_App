import 'dart:async';

import 'package:attendance_app/DAL/ExclFile.dart';
import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/student.dart';
import 'package:flutter/material.dart';

class ViewAbsentStudent extends StatefulWidget {
  final String department;
  final String level;
  final String subject;
  final String tableName;
  ViewAbsentStudent(
      {Key? key,
      required this.department,
      required this.level,
      required this.tableName,
      required this.subject})
      : super(key: key);

  @override
  State<ViewAbsentStudent> createState() => _ViewAbsentStudentState();
}

class _ViewAbsentStudentState extends State<ViewAbsentStudent> {
  Timer? timer;
  String searchString = '';
  late List<Student> absentStudent;
  late Future<List<Student>> studentList;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    studentList = StudentsDB.readAbsentStudents(
        tableName: widget.tableName,
        department: widget.department,
        level: widget.level,
        subject: widget.subject);

    StudentsDB.readAbsentStudents(
            tableName: widget.tableName,
            department: widget.department,
            level: widget.level,
            subject: widget.subject)
        .then((value) => absentStudent = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض الطلاب الغياب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              },
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'اسم الطالب',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.blue)),
              ),
            ),
            ElevatedButton(
              child: Text(
                'حفظ الطلاب الغائبون في ملف اكسل',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                if (absentStudent.isEmpty) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Color(0xff1f2c34),
                      content: Text('لا يوجد طلاب غائبون',
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
                  String path = '/storage/emulated/0/الطلاب الغائبون/';
                  ExcelFile.createExcelFileForAbsent(absentStudent,
                      widget.department, widget.level, widget.subject, path);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Color(0xff1f2c34),
                      content: Text('تم تصدير وحفظ الملف بنجاح',
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
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تاريخ الغياب',
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
              child: FutureBuilder<List<Student>>(
                future: studentList, //read students list here
                builder: (BuildContext context,
                    AsyncSnapshot<List<Student>> snapshot) {
                  //if snapshot has no data yet
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Loading...'),
                        ],
                      ),
                    );
                  }
                  //if snapshot return empty [], show text
                  //else show student list
                  return snapshot.data!.isEmpty
                      ? Center(
                          child: Text('لا يوجد'),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (searchString.isNotEmpty) {
                              if (snapshot.data![index].name
                                  .contains(searchString)) {
                                return Center(
                                  child: ListTile(
                                    leading: Text(
                                      '${snapshot.data![index].createdTime.year}.${snapshot.data![index].createdTime.month}.${snapshot.data![index].createdTime.day}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    title: Text(
                                      snapshot.data![index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    trailing: Text(
                                      snapshot.data![index].studentID,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Center(
                                child: ListTile(
                                  leading: Text(
                                    '${snapshot.data![index].createdTime.year}.${snapshot.data![index].createdTime.month}.${snapshot.data![index].createdTime.day}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  title: Text(
                                    snapshot.data![index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Text(
                                    snapshot.data![index].studentID,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }
                          });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
