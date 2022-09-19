import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KayitFormu extends StatefulWidget {
  const KayitFormu({Key? key}) : super(key: key);

  @override
  State<KayitFormu> createState() => _KayitFormuState();
}

bool kayitDurumu = false;
late String kullaniciAdi, email, sifre;

class _KayitFormuState extends State<KayitFormu> {
  final _alinanKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _alinanKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/to_do_list.jpg',
              height: MediaQuery.of(context).size.height / 4,
            ),
          ),
          if (!kayitDurumu)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: ((alinankullanici) {
                  kullaniciAdi = alinankullanici;
                }),
                validator: (alinankullanici) {
                  // return alinansifre!.isEmpty ? 'en az 6 karakter' : null;
                  if (alinankullanici!.isEmpty) {
                    return 'Bos birakma';
                  }
                  return null;

                  //return alinankullanici!.isEmpty ? null : 'bos birakma';
                },
                decoration: InputDecoration(
                    labelText: 'Kullanici adi girin',
                    border: OutlineInputBorder()),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (alinanmail) {
                email = alinanmail;
              },
              validator: (alinanmail) {
                //return alinanmail!.isEmpty ? 'contains @' : null;
                if (!alinanmail!.contains('@')) {
                  return 'Lutfen @ kullan';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email girin',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              onChanged: (alinansifre) {
                sifre = alinansifre;
              },
              validator: (alinansifre) {
                // return alinansifre!.isEmpty ? 'en az 6 karakter' : null;
                if (alinansifre!.length <= 6) {
                  return 'En az alti karakter';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelText: 'Password girin', border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  kayitEkle();
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 33, 60, 101)),
                child: kayitDurumu
                    ? Text(
                        "Giris Yap",
                        style: TextStyle(fontSize: 25),
                      )
                    : Text(
                        "Kaydol",
                        style: TextStyle(fontSize: 25),
                      )),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  kayitDurumu = !kayitDurumu;
                });
              },
              child:
                  kayitDurumu ? Text('Hesabim yok') : Text('Zaten hesabim var'))
        ],
      ),
    );
  }

  void kayitEkle() {
    if (_alinanKey.currentState!.validate()) {
      formTeslimEt(kullaniciAdi, email, sifre);
    }
  }
}

formTeslimEt(String kullaniciAdi, String email, String sifre) async {
  final yetki = FirebaseAuth.instance; //yetki aldiriyor
  UserCredential yetkisonucu;
  if (kayitDurumu) {
    yetkisonucu =
        await yetki.signInWithEmailAndPassword(email: email, password: sifre);
  } else {
    yetkisonucu = await yetki.createUserWithEmailAndPassword(
        email: email, password: sifre);
    String uidTutucu = yetkisonucu.user!.uid;
    await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(uidTutucu)
        .set({"kullaniciadi": kullaniciAdi, "email": email});
  }
}
