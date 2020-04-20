
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:uslabs_assignment/screens/contacts/contacts.dart';
import 'package:uslabs_assignment/screens/home/home.dart';
import 'package:uslabs_assignment/screens/location/location.dart';
import 'package:uslabs_assignment/screens/logs/logs.dart';

class MainScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const MainScreen({Key key, this.documentSnapshot}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> widgets;

  @override
  void initState() {
    widgets = [];
    widget.documentSnapshot.data.forEach((key, value) {
      widgets.add(Text(value.toString()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
        body: widget.documentSnapshot == null
            ? Center(
                child: Text("Some Error Occured"),
              )
            : Center(
                child: Container(
                  width: size.width * 0.8,
                  child: ProfilePage(
                    documentSnapshot: widget.documentSnapshot,
                  ),
                ),
              ));
  }
}

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const ProfilePage({Key key, this.documentSnapshot}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controller1;
  TextEditingController _controller2;
  TextEditingController _controller3;
  TextEditingController _controller4;
  TextEditingController _controller5;
  String password;
  Map<String, dynamic> data;
  @override
  void initState() {
    data = widget.documentSnapshot.data;
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    _controller5 = TextEditingController();

    _controller1.text = data['firstName'];
    _controller2.text = data['secondName'];
    _controller3.text = data['email'];
    _controller5.text = data.containsKey('phone')
        ? data['phone'].toString()
        : data['phone'] == 0 ? null : data['phone'].toString();
    password = data['password'];

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'First Name', icon: Icon(Icons.person)),
                controller: _controller1,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Last Name', icon: Icon(Icons.person_outline)),
                controller: _controller2,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(hintText: 'Email', icon: Icon(Icons.mail)),
                controller: _controller3,
                onChanged: (value) {
                  print(value);
                },
                validator: (value) {
                  Pattern pattern =
                      r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(value))
                    return "Please Enter Valid Email";
                  else
                    return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Password', icon: Icon(Icons.vpn_key)),
                controller: _controller4,
                validator: (value) {
                  if (password != value)
                    return "Enter correct old password";
                  else
                    return null;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: _controller5,
                maxLength: 10,
                validator: (value) {
                  if (value.length < 10)
                    return "Enter correct phone number";
                  else
                    return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: "Enter your phone number",
                  suffixText: 'IN',
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Updating...')));
                    Firestore.instance
                        .collection("users")
                        .document(data['uid'])
                        .setData({
                      "uid": data['uid'],
                      "firstName": _controller1.text.trim(),
                      "secondName": _controller2.text.trim(),
                      "email": _controller3.text.trim(),
                      "password": _controller4.text.trim(),
                      "phone": int.parse(_controller5.text),
                      "imgUrl": null
                    }).then((result) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Updated!!')));
                    }).catchError((err) {
                      final snackBar = SnackBar(
                        content: Text(err.toString()),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  }
                },
                child: Text("Update Details"),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () async {
                  Map<Permission, PermissionState> permission =
                      await PermissionsPlugin.requestPermissions(
                          [Permission.READ_CONTACTS]);
                  permission.forEach((key, value) {
                    if (value == PermissionState.GRANTED) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Contacts()));
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Permission Denied!!')));
                    }
                  });
                },
                child: Text("Contacts"),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () async {
                  Map<Permission, PermissionState> permission =
                      await PermissionsPlugin.requestPermissions(
                          [Permission.READ_CALL_LOG]);
                  permission.forEach((key, value) {
                    if (value == PermissionState.GRANTED) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CallLogs()));
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Permission Denied!!')));
                    }
                  });
                },
                child: Text("Call Logs"),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () async {
                  Map<Permission, PermissionState> permission =
                      await PermissionsPlugin.requestPermissions(
                          [Permission.ACCESS_FINE_LOCATION]);
                  permission.forEach((key, value) {
                    if (value == PermissionState.GRANTED) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GetLocationWidget()));
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Permission Denied!!')));
                    }
                  });
                },
                child: Text("Get Location"),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(onPressed: (){
                FirebaseAuth.instance.signOut().then((result) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                        (_) => false));
              }, child: Text("Sign Out"),)
            ],
          ),
        ),
      ),
    );
  }
}
