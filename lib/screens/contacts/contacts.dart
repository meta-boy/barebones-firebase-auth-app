import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts;
  Future<bool> getContacts() async {
    try {
      Iterable<Contact> c = await ContactsService.getContacts();
      contacts = c.toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    getContacts().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: contacts == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(contacts[index].displayName == null
                            ? " "
                            : contacts[index].displayName),
                        subtitle: Text(contacts[index].phones.isNotEmpty
                            ? contacts[index].phones.first.value
                            : ""),
                        leading: contacts[index].avatar.isNotEmpty
                            ? Image.memory(contacts[index].avatar)
                            : Container(
                                height: 60,
                                width: 60,
                                color: Colors.blue,
                                child: Center(
                                    child: Text(
                                        contacts[index]
                                            .androidAccountName
                                            .substring(0, 1),
                                        style: TextStyle(color: Colors.white))),
                              ),
                      ),
                      Divider()
                    ],
                  );
                },
              ));
  }
}
