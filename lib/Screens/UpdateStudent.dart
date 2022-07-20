import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/student.dart';
import 'package:flutter/material.dart';

class UpdateStudent extends StatefulWidget {
  final Student student;
  final int id;
  UpdateStudent({Key? key, required this.student, required this.id})
      : super(key: key);

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  late final DateTime createdTime;
  final _studentID = TextEditingController();
  final _name = TextEditingController();
  final _mac = TextEditingController();
  late String department;
  late String level;
  static const menuItems1 = <String>[
    'IT',
    'CS',
  ];
  static const menuItems2 = <String>[
    '1',
    '2',
    '3',
    '4',
  ];
  final List<DropdownMenuItem<String>> dropdownMenuItem1 = menuItems1
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final List<DropdownMenuItem<String>> dropdownMenuItem2 = menuItems2
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  void initState() {
    _studentID.text = widget.student.studentID;
    _name.text = widget.student.name;
    _mac.text = widget.student.mac;
    department = widget.student.department;
    level = widget.student.level;
    super.initState();
  }

  @override
  void dispose() {
    _studentID.dispose();
    _name.dispose();
    _mac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات طالب'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(true),
          //to prevent back button pressed without add/update
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              _buildTextField(_studentID, 'الرقم الجامعي للطالب'),
              SizedBox(
                height: 30,
              ),
              _buildTextField(_name, 'اسم الطالب'),
              SizedBox(
                height: 30,
              ),
              _buildTextField(_mac, 'MAC ex: 84:38:38:ff:ee:5b'),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: DropdownButton<String>(
                  value: department,
                  onChanged: (String? newValue) {
                    setState(() {
                      department = newValue!;
                    });
                  },
                  items: this.dropdownMenuItem1,
                ),
                trailing: Text(
                  'الرجاء اختيارالتخصص',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(
                height: 20,
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () async {
                  if (_studentID.text.isNotEmpty &&
                      _name.text.isNotEmpty &&
                      _mac.text.isNotEmpty) {
                    await StudentsDB.deleteStudents(widget.id);
                    createdTime = DateTime.now();
                    await StudentsDB.createStudents(
                        Student(
                            studentID: _studentID.text,
                            name: _name.text,
                            level: level,
                            department: department,
                            mac: _mac.text.toLowerCase(),
                            createdTime: createdTime),
                        'student');
                    Navigator.of(context).pop(true);
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xff1f2c34),
                        content: Text('الرجاء ادخال جميع بيانات الطالب ',
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
                child: Text(
                  'حفظ التغيرات',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(
      TextEditingController _controller, String hint) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
