
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ios_agenda_ore/database/giornate.dart';
import 'package:ios_agenda_ore/giorno.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';



class Calendario0 extends StatelessWidget {
  final Function goback;
  final List giorni;
  List orario;
  final DateTime data;
  var box = Hive.box('database');
  Calendario0(this.data,this.giorni,this.goback);

  final String languageCode = ui.window.locale.languageCode;
  String mese;

  final DateTime verdata = DateTime.now();


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
              String datas = giorni[index] + ' '+mese;
              if (giorni[index] == "") {
                return Container();
              } else {
                return InkWell(
                  child: Hero(
                    tag: datas,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),

                      color: giorni[index] == verdata.day.toString() &&
                          data.month == verdata.month
                          && data.year == verdata.year
                          ? Colors.grey[300]
                          : Colors.white,

                      child: Column(
                        children: [
                          Expanded(
                            child: Text(giorni[index], style: TextStyle(
                                fontSize: 20, color: Colors.blue),),
                          ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(orai != null ? orai.totale : '',style: TextStyle(fontSize: 14,color: Colors.black),)
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                  onTap: () {

                    if (data.year < verdata.year ||
                        data.year == verdata.year && data.month < verdata.month ||
                        data.year == verdata.year && data.month == verdata.month && int.parse(giorni[index]) <= verdata.day ){
                      Navigator.of(context).push(
                        PageRouteBuilder<Null>(
                            pageBuilder: (BuildContext context, Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return AnimatedBuilder(
                                  animation: animation,
                                  builder: (BuildContext context, Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: Giorno(datas,goback),
                                    );
                                  });
                            },
                            transitionDuration: Duration(milliseconds: 500)),
                      );
                    }

                   // Navigator.push(context,
                   //     MaterialPageRoute( builder: (context) => Giorno(datas,goback)));

                  },
                );
              }
            },
          )
      );
    }

}