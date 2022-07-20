class Student {
  int? id;
  String studentID;
  String name;
  String department;
  String level;
  String mac;
  String? subject;
  DateTime createdTime;

  Student(
      {this.id,
      required this.studentID,
      required this.name,
      required this.level,
      required this.department,
      required this.mac,
      this.subject,
      required this.createdTime});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        studentID: json['studentID'],
        name: json['name'],
        department: json['department'],
        level: json['level'],
        mac: json['mac'],
        createdTime: DateTime.parse(json['createdTime']),
      );

        factory Student.absentFromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        studentID: json['studentID'],
        name: json['name'],
        department: json['department'],
        level: json['level'],
        mac: json['mac'],
        subject: json['subject'],
        createdTime: DateTime.parse(json['createdTime']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentID': studentID,
        'name': name,
        'department': department,
        'level': level,
        'mac': mac,
        'createdTime': createdTime.toIso8601String(),
      };

        Map<String, dynamic> absentToJson() => {
        'id': id,
        'studentID': studentID,
        'name': name,
        'department': department,
        'level': level,
        'mac': mac,
        'subject': subject,
        'createdTime': createdTime.toIso8601String(),
      };
}
