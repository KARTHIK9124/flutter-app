class Person {
  int? id;
  String name;
  String city;

  Person({
    this.id,
    required this.name,
    required this.city,
  });

  // Convert the Person object to a Map object
  Map<String, Object?> toMap() {
    return {
      'name': name,
      'city': city,
    };
  }

  // Create a Person object from a Map object
  factory Person.fromMap(Map<String, Object?> json) {
    return Person(
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String,
    );
  }
}
