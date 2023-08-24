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
                  background: Container(color: Color.fromARGB(255, 58, 33, 243)),
                  onDismissed: (direction) {
                    PersonDatabaseProvider.db.deletePersonWithId(item!.id!);
                  },
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        item!.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.email, size: 16, color: Colors.blue),
                              SizedBox(width: 5),
                              Text(item.email),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: Colors.green),
                              SizedBox(width: 5),
                              Text(item.phone_number),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.place, size: 16, color: Colors.orange),
                              SizedBox(width: 5),
                              Text(item.address),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.purple),
                              SizedBox(width: 5),
                              Text(item.postal_code),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: item.active ? Colors.green : Colors.red),
                              SizedBox(width: 5),
                              Text(item.active ? 'Active' : 'Inactive', style: TextStyle(color: item.active ? Colors.green : Colors.red)),
                            ],
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        child: Text(
                          item.id.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditPerson(
                            true,
                            person: item,
                          ),
                        ));
                      },
                    ),
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
