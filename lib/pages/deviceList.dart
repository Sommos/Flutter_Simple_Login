// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

import '../services/device.dart';

class DevicesList extends StatefulWidget {
  var devicesId;

  DevicesList(List<String> deviceIds, {super.key, required this.devicesId});

  @override
  State<DevicesList> createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  DatabaseReference deviceRef = FirebaseDatabase.instance.ref('device');

  List<Device> _devicesListArray = [
    // Device(name: 'A', id: 'd', isRunning: true),
  ];

  @override
  void initState() {
    super.initState();
    List<String> devicesId = widget.devicesId;
    // print('cccc${ widget.devicesId.toString()}');
    fetchDevices(devicesId);
  }

  String databasejson = "";
  int countvalue = 0;

  Widget renderDeviceList(List<Device> devices) {
    return Column(
      children: devices.map((device) => renderDeviceRow(device)).toList(),
    );
  }

  Widget renderDeviceRow(Device device) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(device.name),
        Switch(
          value: device.isRunning,
          onChanged: (value) async {
            handleToggleChange(device.id, value);
          },
        ),
      ],
    );
  }

  void listenToDevice(String deviceId, int listIndex) {
    deviceRef.child(deviceId).onValue.listen((event) {
      // Do something with the event data.
      final Map<String, dynamic> data =
          event.snapshot.value as Map<String, dynamic>;

      var device = Device.fromJson(data);

      _devicesListArray[listIndex] = device;

      setState(() {
        _devicesListArray = _devicesListArray;
      });
    });
  }

  Future<void> fetchDevices(List<String> devicesId) async {
    // print('ccc $devicesId');

    List<Device> devices = await Future.wait(
      devicesId.map((deviceId) async {
        final DataSnapshot data = await deviceRef.child(deviceId).get();
        var map =
            Map<String, dynamic>.from(data.value as Map<dynamic, dynamic>);

        int listIndex = devicesId.indexOf(deviceId);
        listenToDevice(deviceId, listIndex);

        return Device.fromJson(map);
      }),
    );

    print(devices.length);

    // Update the UI with the list of devices.
    setState(() {
      _devicesListArray = devices;
    });
  }

  Future<void> handleToggleChange(String id, bool value) async {
    // If the request is successful, change the state or refresh to do fetch
    // The value represents the value after change
    try {
      await deviceRef.child(id).update({
        'isRunning': value,
      });
      setState(() {});
      // print('aaa  $id');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Devices List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ))),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // logo
                  const Icon(
                    Icons.devices_other,
                    color: Colors.black,
                    size: 75,
                  ),

                  const SizedBox(height: 50),
                  renderDeviceList(_devicesListArray)
                ],
              ),
            ),
          ),
        ));
  }
}
