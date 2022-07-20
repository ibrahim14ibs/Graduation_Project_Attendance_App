import 'package:attendance_app/DAL/StudentsDB.dart';
import 'package:attendance_app/Models/departement.dart';
import 'package:flutter/material.dart';

class AddDepartement extends StatefulWidget {
  const AddDepartement({Key? key}) : super(key: key);

  @override
  State<AddDepartement> createState() => _AddDepartementState();
}

class _AddDepartementState extends State<AddDepartement> {
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة تخصص'),
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
              _buildTextField(_name, 'اسم التخصص'),
              SizedBox(
                height: 30,
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
                  if (_name.text.isNotEmpty) {
                    await StudentsDB.createDepartement(
                        Departement(name: _name.text));
                    Navigator.of(context).pop(true);
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xff1f2c34),
                        content: Text('الرجاء ادخال اسم التخصص ',
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
                  'اضافة تخصص جديد',
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
