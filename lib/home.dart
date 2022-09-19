import 'package:flutter/material.dart';
import 'kayitForm.dart';

class MyHomePge extends StatefulWidget {
  const MyHomePge({Key? key}) : super(key: key);

  @override
  State<MyHomePge> createState() => _MyHomePgeState();
}

class _MyHomePgeState extends State<MyHomePge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayit Ekrani'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 33, 60, 101),
      ),
      body: KayitFormu(),
    );
  }
}
