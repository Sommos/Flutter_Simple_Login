import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../components/textfield.dart';
import '../components/button.dart';
import '../services/device.dart';

class AddDevice extends StatefulWidget {
  AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final deviceIdController = TextEditingController();
  final deviceNameController = TextEditingController();

  late final FirebaseDatabase _dbref = FirebaseDatabase.instance;
  String databasejson = "";
  int countvalue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // ignore: unused_element
  void _createNewDevice(deviceId, deviceName) {
    //TODO: Add validation to prevent user from add exist device
    //if the device already on the user add validation on here
    // if included from props array
    var device = Device(
      name: deviceName,
      id: deviceId,
    );
    _dbref.ref('device/$deviceId').once().then((e) {
      _dbref
          .ref("user")
          .child(userId)
          .child("devices")
          .child(deviceId)
          .set({deviceId: true});

      if (e.snapshot.exists) {
        // if The device already exists
        //do add new user to the device
        _dbref
            .ref("device")
            .child(deviceId)
            .child("users")
            .child(userId)
            .set({userId:true});
      } else {
        //add user id to device 
        _dbref.ref("device").child(deviceId).set({
          'name': device.name,
          'id': device.id,
          'isConnected': device.isConnected,
          'isRunning': device.isRunning,
          'users': {userId: {userId:true}}
        });

      }
    });
    Navigator.pop(context);
  }

  addDeviceAction() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    print("dddd ${deviceIdController.text}-${deviceNameController.text}");

    // try creating the user
    String deviceName = deviceNameController.text;
    String deviceId = deviceIdController.text;

    //TODO: ADD validation on UI
    if (deviceName.isEmpty || deviceId.isEmpty) {
      return;
    }

    try {
      _createNewDevice(deviceId, deviceName);

      Navigator.pop(context);
      // pop loading circle
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      print(e);
      Navigator.pop(context);
      //TODO: Add error handler
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Quick Setup ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ))),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 99),

                // logo
                const Icon(
                  Icons.devices,
                  color: Colors.black,
                  size: 75,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text("Let's set up the new Device ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),

                const SizedBox(height: 25),

                // username text field
                MyTextField(
                  controller: deviceIdController,
                  hintText: "Device ID",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password text field
                MyTextField(
                  controller: deviceNameController,
                  hintText: "Device Name",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // sign up button
                MyButton(
                  onTap: addDeviceAction,
                  message: "Add Device",
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),
        ));
  }
}
