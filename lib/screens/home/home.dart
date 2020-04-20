import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uslabs_assignment/screens/main/profile.dart';
import 'package:uslabs_assignment/screens/register/register.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: MyForm());
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  TextEditingController _controller1;
  TextEditingController _controller2;
  @override
  void initState() {
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading ? Center(child: CircularProgressIndicator(),) :Align(
      alignment: Alignment.center,
      child: Container(
        width: size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration:
                    InputDecoration(hintText: 'Email', icon: Icon(Icons.mail)),
                controller: _controller1,
                validator: (value) {
                  Pattern pattern =
                      r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(value.trim()))
                    return "Please Enter Valid Email";
                  else
                    return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Password',
                    icon: Icon(Icons.vpn_key),
                    errorMaxLines: 2),
                controller: _controller2,
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
                  if (_formKey.currentState.validate()) {
                    setState(() {
                                  loading = true;
                                });
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Processing Data, Logging in...')));
                        FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _controller1.text.trim(),
                            password: _controller2.text.trim())
                        .then((currentUser) => Firestore.instance
                                .collection("users")
                                .document(currentUser.user.uid)
                                .get()
                                .then((DocumentSnapshot result) {
                              if (result != null) {
                                
                                return Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MainScreen(documentSnapshot: result,)))
                                    .catchError((err) {
                                      setState(() {
                                  loading = false;
                                });
                                  final snackBar = SnackBar(
                                    content: Text(err.toString()),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                final snackBar = SnackBar(
                                  content: Text("Wrong credentials"),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                              print(result);
                              return result;
                            }).catchError((err) {
                              final snackBar = SnackBar(
                                content: Text(err.toString()),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }))
                        .catchError((err) {
                      print(err);
                      setState(() {
                                  loading = false;
                                });
                      final snackBar = SnackBar(
                        content: Text(err.toString()),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    });
                  } else {
                    setState(() {
                                  loading = false;
                                });
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('BLEHhhh...')));
                  }
                },
                child: Text("Login"),
              ),
              RaisedButton(
                onPressed: () {

                  Navigator.push(

                      context, MaterialPageRoute(builder: (_) => Register()));
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
