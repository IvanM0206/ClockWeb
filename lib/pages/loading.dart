import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:world_time/servicies/world_time.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldtime() async {
    WorldTime instance = WorldTime(location: 'Buenos Aires', flag: 'argentina', url: 'America/Argentina/Buenos_Aires');
    await instance.Get_time();
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
    });
  }

  void initState() {
    super.initState();
    setupWorldtime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(50.0),
        child: Text('loading'),
      ),
    );
  }
}
