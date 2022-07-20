class Subject {
  int? id;
  String name;
  String departement;
  String level;
  Subject(
      {this.id,
      required this.name,
      required this.departement,
      required this.level});

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        name: json['name'],
        departement: json['departement'],
        level: json['level'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'departement': departement,
        'level': level,
      };
}
