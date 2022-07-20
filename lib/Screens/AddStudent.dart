import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/departement.dart';
import 'package:attendance_app/Models/student.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  late final DateTime createdTime;
  final _studentID = TextEditingController();
  final _name = TextEditingController();
  final _mac = TextEditingController();

  static const menuItems2 = <String>[
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

  String? departement;
  Set<String> departementName = Set();
  String level = '4';

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
        title: Text('اضافة طالب'),
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
              SizedBox(
                height: 20,
              ),
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
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () async {
                  if (_studentID.text.isNotEmpty &&
                      _name.text.isNotEmpty &&
                      _mac.text.isNotEmpty &&
                      departement != null) {
                    createdTime = DateTime.now();
                    await StudentsDB.createStudents(
                        Student(
                            studentID: _studentID.text,
                            name: _name.text,
                            level: level,
                            department: departement!,
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
                  'اضافة طالب',
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
