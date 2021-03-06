import 'package:digi_queue/Customer/after_lg_su/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

Widget drawer(context, customerName, customerEmail, customerPhoto) {
  return Drawer(
    elevation: 1.5,
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.deepPurpleAccent[400]),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 100,
                  width: 100,
                  child: customerPhoto == null
                      ? CircleAvatar(
                          backgroundColor: Colors.deepPurple[700],
                          radius: 40,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(customerPhoto),
                          radius: 40,
                          backgroundColor: Colors.deepPurple[700],
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  customerName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  customerEmail,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.account_circle,
            color: Colors.deepPurple[700],
          ),
          title: Text("Account"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Account();
            }));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.adjust,
            color: Colors.deepPurple[700],
          ),
          title: Text("Contact Us"),
          onTap: () {
            _sendEmail(
                "mailto:rajsingharia.1234@gmail.com?subject=Digi Queue App&body=",
                context);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.deepPurple[700],
          ),
          title: Text("Log Out"),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HPage();
            }));
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Image.asset('assets/images/logo.jpg'),
              title: Text("V 1.0.0"),
              subtitle: Text("Made in India"),
            ),
          ),
        )
      ],
    ),
  );
}

Future<void> _sendEmail(String command, context) async {
  if (await canLaunch(command)) {
    await launch(
      command,
    );
  } else {
    Fluttertoast.showToast(
      msg: "Unable To Send Email",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
