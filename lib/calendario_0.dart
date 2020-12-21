
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ios_agenda_ore/database/giornate.dart';
import 'package:ios_agenda_ore/giorno.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';



class Calendario_0 extends StatelessWidget {
  Function goback;
  List giorni,orario;
  DateTime data;
  var box =Hive.box('database');
  Calendario_0(this.data,this.giorni,this.goback);

  String languageCode = ui.window.locale.languageCode;
  String mese;

  DateTime verdata = DateTime.now();


  @override
  Widget build(BuildContext context) {

      mese = DateFormat('MMMM yyyy', languageCode).format(data);
      mese = mese[0].toUpperCase() + mese.substring(1);
      return Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(

            itemCount: giorni.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 0.65),
            itemBuilder: (BuildContext context, int index) {
              var orai = box.get(giorni[index]+' ' + mese) as Giornate;

              if (giorni[index] == "") {
                return Container();
              } else {
                return InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),

                    color: giorni[index] == verdata.day.toString() &&
                        data.month == verdata.month
                        && data.year == verdata.year
                        ? Colors.grey[300]
                        : Colors.white,

                    child: Column(
                      children: [
                        Text(giorni[index], style: new TextStyle(
                            fontSize: 20, color: Colors.blue),),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(orai != null ? orai.totale : '')
                        )

                      ],
                    ),
                  ),
                  onTap: () {
                    String datas = giorni[index] + ' '+mese;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Giorno(datas,goback)));

                  },
                );
              }
            },
          )
      );
    }

}