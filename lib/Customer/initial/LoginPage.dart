import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:digi_queue/Customer/after_lg_su/Home.dart';
import 'package:digi_queue/animation/FadeAnimation.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "", _password = "";
  Box<String> whoAreYou;
  Box<String> userId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    whoAreYou = Hive.box<String>("whoAreYou");
    userId = Hive.box<String>("userId");
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? AlertDialog(
            title: Center(
              child: Text(
                "Loading",
              ),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 6,
              child: Center(
                child: SpinKitWave(
                  color: Colors.deepPurple[700],
                ),
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                                1.2,
                                Text(
                                  "Login to your account",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[700]),
                                )),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(
                                  1.2,
                                  TextField(
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(),
                                        labelText: "Email"),
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                  1.3,
                                  TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        border: OutlineInputBorder(),
                                        labelText: "Password"),
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                  )),
                            ],
                          ),
                        ),
                        FadeAnimation(
                            1.4,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 50,
                                  onPressed: () {
                                    if (_email == "" || _password == "") {
                                      Fluttertoast.showToast(
                                          msg: "Credentials Empty",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      setState(() => isLoading = true);
                                      FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _email,
                                              password: _password)
                                          .then((value) {
                                        whoAreYou.putAt(0, "customer");
                                        userId.putAt(
                                            0, value.user.uid.toString());
                                        if (value.user != null) {
                                          print(value.user.uid);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Home();
                                          }));
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "User Not Created",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }).catchError((e) {
                                        Fluttertoast.showToast(
                                          msg: e.message.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    }
                                  },
                                  color: Colors.deepPurpleAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                        FadeAnimation(
                            1.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account?"),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SignUpPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
