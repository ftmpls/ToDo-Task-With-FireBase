import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GorevEkle extends StatefulWidget {
  const GorevEkle({Key? key}) : super(key: key);

  @override
  State<GorevEkle> createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {
  TextEditingController gorevAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();
  veriEkle() async {
    final yetki = FirebaseAuth.instance;
    final User? kullanici = yetki.currentUser;
    String uidTutucu = kullanici!.uid;
    var zamanTutucu = DateTime.now();
    await FirebaseFirestore.instance
        .collection("gorevler")
        .doc(uidTutucu)
        .collection("gorevlerim")
        .doc(zamanTutucu.toString())
        .set({
      "gorevadi": gorevAlici.text,
      "son tarih": tarihAlici.text,
      "tam zaman": zamanTutucu
    });
    Fluttertoast.showToast(msg: "gorev eklendi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gorev Ekle'),
        backgroundColor: Color.fromARGB(255, 33, 60, 101),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            controller: gorevAlici,
            decoration: InputDecoration(
                labelText: "Gorev ekle", border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextFormField(
            controller: tarihAlici,
            decoration: InputDecoration(
                labelText: "Son tarih", border: OutlineInputBorder()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                veriEkle();
              },
              child: Text("Gorev ekle"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 33, 60, 101)),
            ),
          ),
        )
      ]),
    );
  }
}
