class Person {
  int? id;
  String name;
  String first_name; 
  String last_name; 
  String phone_number; 
  String email; 
  String address; 
  String postal_code; 
  bool active; 
  String city;

  Person({
    this.id,
    required this.name,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
    required this.email,
    required this.address,
    required this.postal_code,
    required this.active,
    required this.city,
  });

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        id: json["id"],
        name: json["name"],
        first_name: json["firstName"],
        last_name: json["lastName"],
        phone_number: json["phoneNumber"],
        email: json["email"],
        address: json["address"],
        postal_code: json["postalCode"],
        active: json["active"] == 1, // Assuming 1 means active, 0 means inactive
        city: json["city"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "firstName": first_name,
        "lastName": last_name,
        "phoneNumber": phone_number,
        "email": email,
        "address": address,
        "postalCode": postal_code,
        "active": active ? 1 : 0, // Store as 1 for active, 0 for inactive
        "city": city,
      };
}
