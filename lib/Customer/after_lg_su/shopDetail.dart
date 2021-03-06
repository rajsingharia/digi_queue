import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetail extends StatefulWidget {
  final uid, name, phoneNo, photo, description, address;
  ShopDetail(
      {this.uid,
      this.name,
      this.address,
      this.description,
      this.photo,
      this.phoneNo});

  @override
  _ShopDetailState createState() =>
      _ShopDetailState(uid, name, phoneNo, photo, description, address);
}

class _ShopDetailState extends State<ShopDetail> {
  String uid, name, phoneNo, photo, description, address;
  _ShopDetailState(String uid, name, phoneNo, photo, description, address) {
    this.uid = uid;
    this.name = name;
    this.phoneNo = phoneNo;
    this.photo = photo;
    this.description = description;
    this.address = address;
  }

  var _sellersData;
  bool isLoading = true, isBooked = false, isLoading2 = true;
  List<String> timeLines;
  Map<int, String> book;
  Box<String> userId;
  //Box<List<String>> shopBookedList;
  String bookedTime;

  @override
  void initState() {
    //shopBookedList = Hive.box<List<String>>('shopBookedDetail');
    userId = Hive.box<String>("userId");
    timeLines = List<String>();
    book = Map<int, String>();
    timeLines.addAll({
      '7:00 am',
      '7:20 am',
      '7:40 am',
      '8:00 am',
      '8:20 am',
      '8:40 am',
      '9:00 am',
      '9:20 am',
      '9:40 am',
      '10:00 am',
      '10:20 am',
      '10:40 am',
      '11:00 am',
      '11:20 am',
      '11:40 am',
      '12:00 pm',
      '12:20 pm',
      '12:40 pm',
      '1:00 pm',
      '1:20 pm',
      '1:40 pm',
      '2:00 pm',
      '2:20 pm',
      '2:40 pm',
      '3:00 pm',
      '3:20 pm',
      '3:40 pm',
      '4:00 pm',
      '4:20 pm',
      '4:40 pm',
      '5:00 pm',
      '5:20 pm',
      '5:40 pm',
      '6:00 pm',
      '6:20 pm',
      '6:40 pm',
      '7:00 pm',
      '7:20 pm',
      '7:40 pm',
      '8:00 pm',
      '8:20 pm',
      '8:40 pm',
      '9:00 pm',
      '9:20 pm',
      '9:40 pm',
      '10:00 pm',
      '10:20 pm',
      '10:40 pm',
      '11:00 pm'
    });
    CustomerInfoCrud().getSellerTimeLine(uid).then((result) {
      setState(() {
        _sellersData = result;
        isLoading = false;
      });
    });

    CustomerInfoCrud().getBookedOrNot(uid).then((result) {
      for (int i = 0; i < timeLines.length; i++) {
        if (result.documents[0].data[i.toString()]
                .toString()
                .split('.')
                .first ==
            userId.getAt(0).toString()) {
          setState(() {
            bookedTime = result.documents[0].data[i.toString()]
                .toString()
                .split('.')
                .last;
            isBooked = true;
            isLoading2 = false;
          });
        }
      }
      setState(() {});
      isLoading2 = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading2 == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent[400],
              title: Text("Shop Details"),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 2 + 10,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.0),
                            height: 2 * MediaQuery.of(context).size.height / 9,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.home,
                              color: Colors.deepPurple[700],
                            ),
                            title: Text(name),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.map,
                              color: Colors.deepPurple[700],
                            ),
                            title: Text(address),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.details,
                              color: Colors.deepPurple[700],
                            ),
                            title: Text(description),
                          ),
                          ListTile(
                            onTap: () {
                              _makePhoneCall("tel:$phoneNo", context);
                            },
                            dense: true,
                            leading: Icon(
                              Icons.call,
                              color: Colors.deepPurple[700],
                            ),
                            title: Text(phoneNo),
                          ),
                        ],
                      )),
                  Expanded(
                    child: isBooked == false
                        ? sellerDetailStream()
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Booked at",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  bookedTime,
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.purple[700],
              ),
            ),
          );
  }

  Widget sellerDetailStream() {
    return StreamBuilder(
        stream: _sellersData,
        builder: (context, snapShot) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2, crossAxisCount: 3),
              itemCount: timeLines.length,
              itemBuilder: (context, index) {
                if (snapShot.data != null) {
                  if (snapShot.data.documents[0].data[index.toString()]
                              .toString()
                              .split('.')
                              .first !=
                          "S" &&
                      snapShot.data.documents[0].data[index.toString()]
                              .toString() !=
                          "null") {
                    return Container(
                      padding: EdgeInsets.fromLTRB(9, 8, 9, 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ListTile(
                          dense: true,
                          tileColor: Colors.purple[300],
                          title: Text(timeLines[index])),
                    );
                  } else if (snapShot.data.documents[0].data[index.toString()]
                          .toString() ==
                      "null") {
                    return Container(
                      padding: EdgeInsets.fromLTRB(9, 8, 9, 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ListTile(
                          dense: true,
                          tileColor: Colors.red[300],
                          title: Text(timeLines[index])),
                    );
                  } else if (snapShot.data.documents[0].data[index.toString()]
                              .toString()
                              .split('.')
                              .first ==
                          "S" ||
                      snapShot.data.documents[0].data[index.toString()]
                              .toString() !=
                          "null") {
                    String timeFrame = snapShot
                        .data.documents[0].data[index.toString()]
                        .toString()
                        .split('.')
                        .last;
                    return FlatButton(
                      padding: EdgeInsets.fromLTRB(9, 8, 9, 8),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) =>
                                bottomSheet(timeFrame, index)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: ListTile(
                          tileColor: Colors.grey,
                          dense: true,
                          title: Text(
                            timeFrame,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return SizedBox(
                  height: 0,
                  width: MediaQuery.of(context).size.width,
                );
              });
        });
  }

  Widget bottomSheet(String time, int index) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Book at $time",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.green[300],
                  onPressed: () {
                    isBooked = true;
                    bookedTime = time;
                    String p = userId.getAt(0).toString() + "." + time;

                    //var data;

                    //shopBookedList.add([name, photo, time, uid]);

                    CustomerInfoCrud().addbooking({
                      "name": name,
                      "photo": photo,
                      "time": time,
                    }, userId.getAt(0), name);

                    CustomerInfoCrud()
                        .bookingUpdateOnSellerSide(uid, {index.toString(): p});
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Booked",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                    setState(() {});
                  },
                  child: Text("Book")),
              FlatButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.red[300],
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "Canceled",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNo, context) async {
  if (await canLaunch(phoneNo)) {
    await launch(
      phoneNo,
    );
  } else {
    Fluttertoast.showToast(
      msg: "Unable To Make The Call",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
