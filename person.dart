class Person {
  int id;
  String name;
  String email;

  Person({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert the Person object to a Map object
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Create a Person object from a Map object
  factory Person.fromMap(Map<String, Object?> map) {
    return Person(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
