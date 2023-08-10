import 'package:flutter/material.dart';
import 'database.dart';
import 'person.dart';

class EditPerson extends StatefulWidget {
  final bool edit;
  final Person person;

  EditPerson({required this.edit, required this.person, Key? key})
      : super(key: key);

  @override
  _EditPersonState createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      nameEditingController.text = widget.person.name;
      cityEditingController.text = widget.person.city;
    }
    //Future<List<Person>> person = PersonDatabaseProvider.db.getAllPersons();
    //print(person);
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
                FlutterLogo(
                  size: 300,
                ),
                textFormField(
                  nameEditingController,
                  "Name",
                  "Enter Name",
                  Icons.person,
                  widget.edit ? widget.person.name : "",
                ),
                textFormField(
                  cityEditingController,
                  "city",
                  "Enter city",
                  Icons.email,
                  widget.edit ? widget.person.city : "",
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter valid data')),
                      );
                    } else {
                      if (widget.edit) {
                        // Update an existing person
                        Person updatedPerson = Person(
                          id: widget.person.id,
                          name: nameEditingController.text,
                          city: cityEditingController.text,
                        );
                        await PersonDatabaseProvider.db
                            .updatePerson(updatedPerson);
                      } else {
                        // Add a new person
                        Person newPerson = Person(
                          name: nameEditingController.text,
                          city: cityEditingController.text,
                          id: 0,
                        );
                        await PersonDatabaseProvider.db
                            .addPersonToDatabase(newPerson);
                      }
                      Navigator.pop(context);
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

  TextFormField textFormField(
    TextEditingController t,
    String label,
    String hint,
    IconData iconData,
    String initialValue,
  ) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: t,
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
