import 'package:flutter/material.dart';

import 'database.dart'; 
import 'edit_person.dart';
import 'person.dart';


class PersonListPage extends StatefulWidget {
  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person List'),
      ),
      body: FutureBuilder<List<Person>>(
        future: PersonDatabaseProvider.db.getAllPersons(),
        builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          }
          // Display the list of persons
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              final person = snapshot.data![index];
              return ListTile(
                title: Text(person.name),
                subtitle: Text(person.email),
                leading: CircleAvatar(child: Text(person.id.toString())),
                onTap: () {
                  // Navigate to edit person page when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPerson(
                        edit: true,
                        person: person,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
