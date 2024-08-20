import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  @override

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Choose location screen'),
    );
  }
}
