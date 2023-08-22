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
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              PersonDatabaseProvider.db.deleteAllPersons();
              setState(() {});
            },
            child: Text(
              "Delete all",
              style: TextStyle(color: Colors.yellow),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Person>>(
        future: PersonDatabaseProvider.db.getAllPersons(),
        builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                Person? item = snapshot.data?[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.blue),
                  onDismissed: (direction) {
                    PersonDatabaseProvider.db.deletePersonWithId(item!.id!);
                  },
                  child: ListTile(
                    title: Text(item!.name),
                    subtitle: Text(item!.city),
                    leading: CircleAvatar(child: Text(item.id.toString())),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditPerson(
                          true,
                          person: item,
                        ),
                      ));
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditPerson(false)),
          );
        },
      ),
    );
  }
}