// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import './addDevice.dart';
import './deviceList.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userInfo = FirebaseAuth.instance.currentUser;

  late DatabaseReference _userRef;
  String databasejson = "";
  int countOfRegisteredDevices = 0;
  List<String> devicesId = [];

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.ref('user');
    String userId = userInfo!.uid;

    //To handle add new user
    if (userId.isNotEmpty) {
      _userRef.child(userId).once().then((e) {
        if (e.snapshot.exists) {
          // User exists
        } else {
          // if User does not exist
          print('User does not exist');
          _userRef.child(userId).set(
              {
                'userId': userId,
                 'email': userInfo!.email, 
                 'role': 'user',
                 });
        }
      });
    }

    // to get the device info
    _userRef.child(userId).child('devices').onValue.listen((event) {
      // Print the count of .
      // connected Devices
      // the register Devices
              final Map<String, dynamic> data =
              event.snapshot.value as Map<String, dynamic>;
      final List<String> keys = data.keys.toList();

      print('# ${keys.toString()}');

      print(
          'There are ${event.snapshot.children.length} children in the child.');

      setState(() {
        countOfRegisteredDevices = event.snapshot.children.length;
        devicesId = keys;
      });
    });
  }

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${userInfo!.email}'), actions: [
        IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.logout,
            ))
      ]),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Welocome To Switch-IoT",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "Registered Devices",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(33.0),
                  child: Text(
                    '$countOfRegisteredDevices',
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green[500]),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddDevice()),
                        );
                      },
                      child: const Text(
                        "Add new Device",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 34),
                  child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => DevicesList(devicesId, devicesId: devicesId,),),
                        );
                      },
                      child: const Text(
                        "Devices List",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
