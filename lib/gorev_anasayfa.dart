import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/gorevEkle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  late String mevcutkullaniciid;
  @override
  void initState() {
    mevcutKullaniciAl();
    super.initState();
  }

  @override
  mevcutKullaniciAl() async {
    final yetki = FirebaseAuth.instance;
    final User? mevcutkullanici = yetki.currentUser;
    setState(() {
      mevcutkullaniciid = mevcutkullanici!.uid; //mevcut kullanici id sini tutar
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gorevler"),
        backgroundColor: Color.fromARGB(255, 33, 60, 101),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      //snapshot veritabanindaki tum verileri temsil eder
      body: Container(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("gorevler")
            .doc(mevcutkullaniciid)
            .collection("gorevlerim")
            .snapshots(),
        builder: (context, veriler) {
          //verileri bekliyorsa
          if (veriler.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            final alinanveri = (veriler.data! as QuerySnapshot).docs;
            return ListView.builder(
              itemCount: alinanveri.length,
              itemBuilder: (context, int index) {
                var eklenmezamani = (alinanveri[index]["tam zaman"]).toDate();

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 33, 60, 101),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alinanveri[index]["gorevadi"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat()
                                  .add_yMd()
                                  .add_jm()
                                  .format(eklenmezamani)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alinanveri[index]["son tarih"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("gorevler")
                                  .doc(mevcutkullaniciid)
                                  .collection("gorevlerim")
                                  .doc(
                                      alinanveri[index]["tam zaman"].toString())
                                  .delete();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.yellow,
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 33, 60, 101),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => GorevEkle())));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
