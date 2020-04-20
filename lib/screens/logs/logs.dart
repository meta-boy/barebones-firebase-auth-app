import 'dart:math';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogs extends StatefulWidget {
  @override
  _CallLogsState createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {
  List<CallLogEntry> contacts;
  Future<bool> getContacts() async {
    try {

      Iterable<CallLogEntry> c = await CallLog.get();
      print(c);
      contacts = c.toList();

      return true;
    } catch (e) {
      print(e);
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
  var formatter = new DateFormat('d, EEE');
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
                  print(contacts[index].formattedNumber);
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(contacts[index].name == null
                            ? contacts[index].formattedNumber
                            : contacts[index].name),
                        subtitle: Row(
                          children: <Widget>[
                            Transform.rotate(
                              angle: contacts[index].callType == CallType.missed
                                  ? -pi / 4
                                  : contacts[index].callType ==
                                          CallType.incoming
                                      ? pi / 4
                                      : -3 * pi / 4,
                              child: contacts[index].callType == CallType.missed
                                  ? Icon(
                                      Icons.subdirectory_arrow_right,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.arrow_downward),
                            ),
                            Text(
                                " • ${(contacts[index].duration / 60).floor()}: ${contacts[index].duration % 60} • "),
                            Text(formatter.format(DateTime.fromMillisecondsSinceEpoch(
                                    contacts[index].timestamp))
                                )
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              ));
  }
}
