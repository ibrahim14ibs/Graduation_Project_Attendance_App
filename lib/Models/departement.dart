class Departement {
  int? id;
  String name;
  Departement({this.id, required this.name});

  factory Departement.fromJson(Map<String, dynamic> json) => Departement(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
