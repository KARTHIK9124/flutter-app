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
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneNumberValid = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
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

  void _validateFirstName(String value) {
    setState(() {
      _isFirstNameValid = value.length >= 8 && value.length <= 16;
    });
  }

  void _validateLastName(String value) {
    setState(() {
      _isLastNameValid = value.length >= 6 && value.length <= 16;
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = value.length <= 25 && value.contains('@');
    });
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      _isPhoneNumberValid = value.length <= 12 && int.tryParse(value) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? "Edit Person" : "Add Person"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 300),
                textFormField(
                  controller: nameEditingController,
                  label: "Name",
                  hint: "Enter Name",
                  iconData: Icons.person,
                  initialValue: widget.edit ? widget.person!.name : "",
                  isValid: _isFirstNameValid,
                  validationFunction: _validateFirstName,
                ),
                textFormField(
                  controller: firstNameEditingController,
                  label: "First Name",
                  hint: "Enter First Name",
                  iconData: Icons.person,
                  initialValue: widget.edit ? widget.person!.first_name : "",
                  isValid: _isFirstNameValid,
                  validationFunction: _validateFirstName,
                ),
                textFormField(
                  controller: lastNameEditingController,
                  label: "Last Name",
                  hint: "Enter Last Name",
                  iconData: Icons.person,
                  initialValue: widget.edit ? widget.person!.last_name : "",
                  isValid: _isLastNameValid,
                  validationFunction: _validateLastName,
                ),
                textFormField(
                  controller: cityEditingController,
                  label: "City",
                  hint: "Enter City",
                  iconData: Icons.place,
                  initialValue: widget.edit ? widget.person!.city : "",
                  isValid: true,
                  validationFunction: (value) {},
                ),
                textFormField(
                  controller: phoneNumberEditingController,
                  label: "Phone Number",
                  hint: "Enter Phone Number",
                  iconData: Icons.phone,
                  initialValue: widget.edit ? widget.person!.phone_number : "",
                  isValid: _isPhoneNumberValid,
                  validationFunction: _validatePhoneNumber,
                ),
                textFormField(
                  controller: emailEditingController,
                  label: "Email",
                  hint: "Enter Email",
                  iconData: Icons.email,
                  initialValue: widget.edit ? widget.person!.email : "",
                  isValid: _isEmailValid,
                  validationFunction: _validateEmail,
                ),
                textFormField(
                  controller: addressEditingController,
                  label: "Address",
                  hint: "Enter Address",
                  iconData: Icons.place,
                  initialValue: widget.edit ? widget.person!.address : "",
                  isValid: true,
                  validationFunction: (value) {},
                ),
                textFormField(
                  controller: postalCodeEditingController,
                  label: "Postal Code",
                  hint: "Enter Postal Code",
                  iconData: Icons.location_on,
                  initialValue: widget.edit ? widget.person!.postal_code : "",
                  isValid: true,
                  validationFunction: (value) {},
                ),
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
                        await PersonDatabaseProvider.db
                            .updatePerson(updatedPerson);
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
                        await PersonDatabaseProvider.db
                            .addPersonToDatabase(newPerson);
                      }
                      Navigator.pop(context);
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
    );
  }

  TextFormField textFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData iconData,
    required String initialValue,
    required bool isValid,
    required void Function(String) validationFunction,
  }) {
    return TextFormField(
      onChanged: validationFunction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        } else if (!isValid) {
          return 'Invalid input';
        }
        return null;
      },
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
}
