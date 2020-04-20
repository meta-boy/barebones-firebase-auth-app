import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uslabs_assignment/screens/home/home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController _controller1;
  TextEditingController _controller2;
  TextEditingController _controller3;
  TextEditingController _controller4;

  @override
  void initState() {
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: size.width * 0.8,
        child: Form(
          key: _formKey,
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
                  if (value.length < 6)
                    return "Password should be more than 6 characters long";
                  else
                    return null;
                },
                obscureText: true,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              RaisedButton(
                onPressed: () {
                  print(_controller3.text.trim());
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Processing Data, Registering...')));
                        FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _controller3.text.trim(),
                            password: _controller4.text.trim())
                        .then((currentUser) => Firestore.instance
                            .collection("users")
                            .document(currentUser.user.uid)
                            .setData({
                              "uid": currentUser.user.uid,
                              "firstName": _controller1.text.trim(),
                              "secondName": _controller2.text.trim(),
                              "email": _controller3.text.trim(),
                              "password": _controller4.text.trim(),
                              "phone": 0,
                              "imgUrl": null
                            })
                            .then((result) => {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                      (_) => false),
                                })
                            .catchError((err) {
                              final snackBar = SnackBar(
                                content: Text(err.toString()),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }))
                        .catchError((err) {
                      final snackBar = SnackBar(
                        content: Text(err.toString()),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                        (_) => false);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Blep..')));
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
