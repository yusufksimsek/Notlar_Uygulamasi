// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ogrenci_notlari_uygulamasi/App/NotDetaySayfa.dart';
import 'package:ogrenci_notlari_uygulamasi/App/NotKayitSayfa.dart';
import 'package:ogrenci_notlari_uygulamasi/App/Notlardao.dart';

import 'Notlar.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home:  Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  Future<List<Notlar>> tumNotlarGoster() async {
    var notlarListesi = await Notlardao().tumNotlar();
    return notlarListesi;
}

Future<bool> uygulamayiKapat() async{
    await exit(0);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              uygulamayiKapat();
            },
            icon: Icon(Icons.arrow_back),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Text("Notlar Uygulaması",style: TextStyle(color: Colors.black,fontSize: 16),),
              WillPopScope(
                onWillPop: uygulamayiKapat,
                child: FutureBuilder(
          future: tumNotlarGoster(),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
                var notlarlistesi = snapshot.data;
                double ortalama = 0.0;
                if(!notlarlistesi.isEmpty){
                  double toplam=0.0;
                  for(var n in notlarlistesi){
                  toplam = toplam + (n.not1+n.not2)/2;
                  }
                  ortalama = toplam/notlarlistesi.length;
                }
                return Text("Ortalama: ${ortalama.toInt()}",style: TextStyle(color: Colors.black,fontSize: 13),);
            } else {
                return Text("Ortalama veri yok",style: TextStyle(color: Colors.black,fontSize: 13),);
            }
          }
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Notlar>>(
        future: tumNotlarGoster(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var notlarlistesi = snapshot.data;
            return ListView.builder(
              itemCount: notlarlistesi?.length,
              itemBuilder: (context,indeks){
                var not = notlarlistesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not,)));
                  },
                  child: Card(
                    child: SizedBox(height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(not.ders_adi,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(not.not1.toString()),
                          Text(not.not2.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }else{
            return Center();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
          },
        tooltip: 'Not Ekle',
        child: Icon(Icons.add),
      ),

    );
  }
}
