import 'dart:io';

import 'package:attendance_app/Models/student.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelFile {
  static void createExcelFileForAbsent(List<Student> absentStudents,
      String department, String level, String subject, String path) {
    // Create a new Excel document.
    final Workbook workbook = new Workbook();
//Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
//Add Text.
    sheet.getRangeByName('A1').setText('رقم الطاب ');
//Add Number
    sheet.getRangeByName('B1').setText('اسم الطالب');
//Add DateTime
    sheet.getRangeByName('C1').setText('عدد مرات غياب الطالب');
    //
    sheet.getRangeByName('D1').setText('ملاحضات');
    Set<String> absetnStudentIDSet = Set();

    Set<String> absetnStudentNameSet = Set();

    for (var item in absentStudents) {
      absetnStudentIDSet.add(item.studentID);
      absetnStudentNameSet.add(item.name);
    }

    for (int i = 0; i < absetnStudentIDSet.length; i++) {
      //Add Text.
      sheet
          .getRangeByName('A${i + 2}')
          .setText('${absetnStudentIDSet.elementAt(i)}');
//Add Text.
      sheet
          .getRangeByName('B${i + 2}')
          .setText('${absetnStudentNameSet.elementAt(i)}');
//Add Text.
      int no = 0;
      for (int j = 0; j < absentStudents.length; j++) {
        if (absetnStudentIDSet.elementAt(i) == absentStudents[j].studentID) {
          no++;
        }
      }
      sheet.getRangeByName('C${i + 2}').setText('$no');
      //
      if (no >= 3) {
        sheet.getRangeByName('D${i + 2}').setText('محروم');
      } else {
        sheet.getRangeByName('D${i + 2}').setText(' ');
      }
    }

// Save the document.
//xlsx
    final List<int> bytes = workbook.saveAsStream();
    File(path + " $department$level ($subject).xlsx").writeAsBytes(bytes);
//Dispose the workbook.
    workbook.dispose();
  }

  static String createExcelFile(DateTime time, Set<Student> attendingStudents,
      String department, String level, String subject, String path) {
    // Create a new Excel document.
    final Workbook workbook = new Workbook();
//Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
//Add Text.
    sheet.getRangeByName('A1').setText('رقم الطاب ');
//Add Number
    sheet.getRangeByName('B1').setText('اسم الطالب');
//Add DateTime
    sheet.getRangeByName('C1').setText('التاريخ');

    for (int i = 0; i < attendingStudents.length; i++) {
      //Add Text.
      sheet
          .getRangeByName('A${i + 2}')
          .setText('${attendingStudents.elementAt(i).studentID}');
//Add Text.
      sheet
          .getRangeByName('B${i + 2}')
          .setText('${attendingStudents.elementAt(i).name}');
//Add Text.
      sheet
          .getRangeByName('C${i + 2}')
          .setText('${time.year}.${time.month}.${time.day}');
    }

// Save the document.
//xlsx
    final List<int> bytes = workbook.saveAsStream();
    File(path +
            "(${time.year}.${time.month}.${time.day}) $department$level ($subject).xlsx")
        .writeAsBytes(bytes);
//Dispose the workbook.
    workbook.dispose();

    return attendingStudents.length.toString();
  }
}
