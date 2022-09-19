import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/gorevEkle.dart';
import 'package:to_do/gorev_anasayfa.dart';
import 'package:to_do/kayitForm.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 83, 149, 161),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance
              .authStateChanges(), //veri var mi diye bakiyor

          builder: (context, kullaniciVerisi) {
            if (kullaniciVerisi.hasData) {
              return AnaSayfa();
            } else {
              return MyHomePge();
            } // veri varsa insa ediyor
          }),
    );
  }
}
