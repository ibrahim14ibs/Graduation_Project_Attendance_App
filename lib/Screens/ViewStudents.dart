import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/student.dart';
import 'package:attendance_app/Screens/AddStudent.dart';
import 'package:attendance_app/Screens/UpdateStudent.dart';
import 'package:flutter/material.dart';

class ViewStudents extends StatefulWidget {
  final String department;
  final String level;
  final String tableName;
  ViewStudents(
      {Key? key,
      required this.department,
      required this.level,
      required this.tableName})
      : super(key: key);

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  TextEditingController controller = TextEditingController();
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض الطلاب'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'حذف الطالب',
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
                future: StudentsDB.readStudents(
                    tableName: widget.tableName,
                    department: widget.department,
                    level: widget.level), //read students list here
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
                                  leading: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          backgroundColor: Color(0xff1f2c34),
                                          title: Text(
                                            "هل تريد فعلا خذف الطالب",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          content: Text(
                                              snapshot.data![index].name,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textDirection: TextDirection.rtl),
                                          contentPadding: EdgeInsets.all(8.0),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                await StudentsDB.deleteStudents(
                                                    snapshot.data![index].id!);
                                                setState(() {
                                                  //rebuild widget after delete
                                                });
                                              },
                                              child: const Text('نعم'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('لا'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                                  onTap: () async {
                                    //tap on ListTile, for update
                                    final refresh = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => UpdateStudent(
                                                id: snapshot.data![index].id!,
                                                student: Student(
                                                    studentID: snapshot
                                                        .data![index].studentID,
                                                    name: snapshot
                                                        .data![index].name,
                                                    level: snapshot
                                                        .data![index].level,
                                                    department: snapshot
                                                        .data![index]
                                                        .department,
                                                    mac: snapshot
                                                        .data![index].mac,
                                                    createdTime: snapshot
                                                        .data![index]
                                                        .createdTime))));

                                    if (refresh == true || refresh == null) {
                                      setState(() {});
                                    }
                                  },
                                ));
                              } else {
                                return Container();
                              }
                            } else {
                              return Center(
                                  child: ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await StudentsDB.deleteStudents(
                                        snapshot.data![index].id!);
                                    setState(() {
                                      //rebuild widget after delete
                                    });
                                  },
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
                                onTap: () async {
                                  //tap on ListTile, for update
                                  final refresh = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => UpdateStudent(
                                              id: snapshot.data![index].id!,
                                              student: Student(
                                                  studentID: snapshot
                                                      .data![index].studentID,
                                                  name: snapshot
                                                      .data![index].name,
                                                  level: snapshot
                                                      .data![index].level,
                                                  department: snapshot
                                                      .data![index].department,
                                                  mac:
                                                      snapshot.data![index].mac,
                                                  createdTime: snapshot
                                                      .data![index]
                                                      .createdTime))));

                                  if (refresh == true || refresh == null) {
                                    setState(() {});
                                  }
                                },
                              ));
                            }
                          });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final refresh = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddStudent()));

          if (refresh == true || refresh == null) {
            setState(() {});
          }
        },
      ),
    );
  }
}
