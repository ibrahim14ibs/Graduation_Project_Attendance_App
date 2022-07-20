import 'package:attendance_app/Models/departement.dart';
import 'package:attendance_app/Models/student.dart';
import 'package:attendance_app/Models/subject.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudentsDB {
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'StudentsDB.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    final sql1 = '''CREATE TABLE student(
      id INTEGER PRIMARY KEY,
      studentID TEXT,
      name TEXT,
      department TEXT,
      level TEXT,
      mac TEXT,
      createdTime TEXT
    )''';

    final sql2 = '''CREATE TABLE AbsentStudent(
      id INTEGER PRIMARY KEY,
      studentID TEXT,
      name TEXT,
      department TEXT,
      level TEXT,
      mac TEXT,
      subject TEXT,
      createdTime TEXT
    )''';

    final sql3 = '''CREATE TABLE departement(
      id INTEGER PRIMARY KEY,
      name TEXT
    )''';

    final sql4 = '''CREATE TABLE subject(
      id INTEGER PRIMARY KEY,
      name TEXT,
      departement TEXT,
      level TEXT
    )''';

    await db.execute(sql1);
    await db.execute(sql2);
    await db.execute(sql3);
    await db.execute(sql4);
  }

//stare CRUD for departement
  static Future<int> createDepartement(Departement departement) async {
    Database db = await StudentsDB.initDB();
    return await db.insert('departement', departement.toJson());
  }

  static Future<List<Departement>> readDepartement() async {
    Database db = await StudentsDB.initDB();
    var departement = await db.query('departement', orderBy: 'name');
    List<Departement> departementsList = departement.isNotEmpty
        ? departement.map((details) => Departement.fromJson(details)).toList()
        : [];
    return departementsList;
  }

  static Future<int> updateDepartement(Departement departement) async {
    Database db = await initDB();
    return await db.update('departement', departement.toJson(),
        where: 'id = ?', whereArgs: [departement.id]);
  }

  static Future<int> deleteDepartement(int id) async {
    Database db = await initDB();
    return await db.delete('departement', where: 'id = ?', whereArgs: [id]);
  }

  //end CRUD for departement

//************** **********************************************************************

//stare CRUD for subject

  static Future<int> createSubject(Subject subject) async {
    Database db = await StudentsDB.initDB();
    return await db.insert('subject', subject.toJson());
  }

  static Future<List<Subject>> readSubject(
      {required String departement, required String level}) async {
    Database db = await StudentsDB.initDB();
    var subject = await db.query('subject',
        where: 'departement = ? and level = ?',
        whereArgs: [departement, level],
        orderBy: 'name');
    List<Subject> subjectsList = departement.isNotEmpty
        ? subject.map((details) => Subject.fromJson(details)).toList()
        : [];
    return subjectsList;
  }

  static Future<int> updateSubject(Subject subject) async {
    Database db = await initDB();
    return await db.update('subject', subject.toJson(),
        where: 'id = ?', whereArgs: [subject.id]);
  }

  static Future<int> deleteSubject(int id) async {
    Database db = await initDB();
    return await db.delete('subject', where: 'id = ?', whereArgs: [id]);
  }

  //end CRUD for subject

//**********************************************************************************
  static Future<int> createStudents(Student student, String tableName) async {
    Database db = await StudentsDB.initDB();
    return await db.insert('$tableName', student.toJson());
  }

  static Future<int> createAbsentStudents(
      Student student, String tableName) async {
    Database db = await StudentsDB.initDB();
    return await db.insert('$tableName', student.absentToJson());
  }

  static Future<List<Student>> readStudents(
      {required String tableName,
      required String department,
      required String level}) async {
    Database db = await StudentsDB.initDB();
    var student = await db.query('$tableName',
        where: 'department = ? and level = ?',
        whereArgs: [department, level],
        orderBy: 'studentID');
    List<Student> studentsList = student.isNotEmpty
        ? student.map((details) => Student.fromJson(details)).toList()
        : [];
    return studentsList;
  }

  static Future<List<Student>> readAbsentStudents(
      {required String tableName,
      required String department,
      required String level,
      required String subject}) async {
    Database db = await StudentsDB.initDB();
    var student = await db.query('$tableName',
        where: 'department = ? and level = ? and subject = ?',
        whereArgs: [department, level, subject],
        orderBy: 'name');
    List<Student> studentsList = student.isNotEmpty
        ? student.map((details) => Student.absentFromJson(details)).toList()
        : [];
    return studentsList;
  }

/*
List<Map> result = await db.rawQuery(
    'SELECT * FROM my_table WHERE name=? and last_name=? and year=?', 
    ['Peter', 'Smith', 2019]
);
*/
  static Future<int> updateStudents(Student student) async {
    Database db = await initDB();
    return await db.update('student', student.toJson(),
        where: 'id = ?', whereArgs: [student.id]);
  }

  static Future<int> deleteStudents(int id) async {
    Database db = await initDB();
    return await db.delete('student', where: 'id = ?', whereArgs: [id]);
  }
}
