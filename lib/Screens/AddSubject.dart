import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/departement.dart';
import 'package:attendance_app/Models/subject.dart';
import 'package:flutter/material.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
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

  final _name = TextEditingController();
  String? departement;
  Set<String> departementName = Set();
  String level = '4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة مقرر'),
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
              SizedBox(
                height: 50,
              ),
              _buildTextField(_name, 'اسم المقرر'),
              SizedBox(
                height: 30,
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
                height: 30,
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
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () async {
                  if (_name.text.isNotEmpty && departement != null) {
                    await StudentsDB.createSubject(Subject(
                        name: _name.text,
                        departement: departement!,
                        level: level));
                    Navigator.of(context).pop(true);
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xff1f2c34),
                        content: Text('الرجاء ادخال جميع البيانات  ',
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
                  'اضافة مقرر جديد',
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
