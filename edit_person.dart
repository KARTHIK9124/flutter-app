import 'package:flutter/material.dart';
import 'database.dart';
import 'person.dart';

class EditPerson extends StatefulWidget {
  final bool edit;
  final Person? person;

  EditPerson(this.edit, {this.person})
      : assert(edit == true || person == null);

  @override
  _EditPersonState createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController postalCodeEditingController = TextEditingController();
  bool active = false; // Default inactive

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      // Initialize text controllers with person data
      nameEditingController.text = widget.person!.name;
      firstNameEditingController.text = widget.person!.first_name;
      lastNameEditingController.text = widget.person!.last_name;
      cityEditingController.text = widget.person!.city;
      phoneNumberEditingController.text = widget.person!.phone_number;
      emailEditingController.text = widget.person!.email;
      addressEditingController.text = widget.person!.address;
      postalCodeEditingController.text = widget.person!.postal_code;
      active = widget.person!.active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? "Edit Person" : "Add Person"),
        backgroundColor: Color.fromARGB(255, 67, 64, 251),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 100),
                  SizedBox(height: 10),
                  customTextField(
                    controller: nameEditingController,
                    label: "Name",
                    hint: "Enter Name (5-15 characters)",
                    iconData: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      } else if (value.length < 5 || value.length > 15) {
                        return 'Name should be 5 to 15 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: firstNameEditingController,
                    label: "First Name",
                    hint: "Enter First Name (5-15 characters)",
                    iconData: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      } else if (value.length < 5 || value.length > 15) {
                        return 'First name should be 5 to 15 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: lastNameEditingController,
                    label: "Last Name",
                    hint: "Enter Last Name (5-15 characters)",
                    iconData: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      } else if (value.length < 5 || value.length > 15) {
                        return 'Last name should be 5 to 15 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: cityEditingController,
                    label: "City",
                    hint: "Enter City (max 10 characters)",
                    iconData: Icons.place,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City is required';
                      } else if (value.length < 5 || value.length > 10) {
                        return 'City should have maximum 10 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: phoneNumberEditingController,
                    label: "Phone Number",
                    hint: "Enter Phone Number (10 digits)",
                    iconData: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      } else if (value.length != 10 || int.tryParse(value) == null) {
                        return 'Invalid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: emailEditingController,
                    label: "Email",
                    hint: "Enter Email (max 25 characters)",
                    iconData: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (value.length > 25 || !value.contains('@')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: addressEditingController,
                    label: "Address",
                    hint: "Enter Address (max 30 characters)",
                    iconData: Icons.place,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      } else if (value.length > 30) {
                        return 'Address should only have maximum 30 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  customTextField(
                    controller: postalCodeEditingController,
                    label: "Postal Code",
                    hint: "Enter Postal Code (max 10 digits)",
                    iconData: Icons.location_on,
                    validator: (value) {
                      if (value != null && (value.length > 10 || int.tryParse(value) == null)) {
                        return 'Invalid postal code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    title: Text("Active Status"),
                    value: active,
                    onChanged: (value) {
                      setState(() {
                        active = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_areAllFieldsEmpty()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter at least one field')),
                          );
                        } else {
                          if (widget.edit) {
                            // Update an existing person
                            Person updatedPerson = Person(
                              id: widget.person!.id,
                              name: nameEditingController.text,
                              first_name: firstNameEditingController.text,
                              last_name: lastNameEditingController.text,
                              city: cityEditingController.text,
                              phone_number: phoneNumberEditingController.text,
                              email: emailEditingController.text,
                              address: addressEditingController.text,
                              postal_code: postalCodeEditingController.text,
                              active: active,
                            );
                            await PersonDatabaseProvider.db.updatePerson(updatedPerson);
                          } else {
                            // Add a new person
                            Person newPerson = Person(
                              name: nameEditingController.text,
                              first_name: firstNameEditingController.text,
                              last_name: lastNameEditingController.text,
                              phone_number: phoneNumberEditingController.text,
                              email: emailEditingController.text,
                              address: addressEditingController.text,
                              postal_code: postalCodeEditingController.text,
                              active: active,
                              city: cityEditingController.text,
                            );
                            await PersonDatabaseProvider.db.addPersonToDatabase(newPerson);
                          }
                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter valid data')),
                        );
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField customTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData iconData,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        hintText: hint,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  bool _areAllFieldsEmpty() {
    return nameEditingController.text.isEmpty &&
        firstNameEditingController.text.isEmpty &&
        lastNameEditingController.text.isEmpty &&
        cityEditingController.text.isEmpty &&
        phoneNumberEditingController.text.isEmpty &&
        emailEditingController.text.isEmpty &&
        addressEditingController.text.isEmpty &&
        postalCodeEditingController.text.isEmpty;
  }
}
