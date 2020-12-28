import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ios_agenda_ore/database/datamesi.dart';
import 'dart:ui' as ui;

import 'package:ios_agenda_ore/mesi_0.dart';
class Anno extends StatefulWidget {
  final Function setdata;
  Anno(this.setdata);

  @override
  _Anno createState() => _Anno();

}
class _Anno extends State<Anno>{
  DateTime data = DateTime.now();
  DateTime datapre = DateTime.now();
  DateTime datadop = DateTime.now();
  String languageCode = ui.window.locale.languageCode;
  List mesiAnno;
  String date;
  var box;
  int current;
  PageController controller =PageController(initialPage: 1,keepPage: false);


  @override
  void initState() {
    mesiAnno = ['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'];
    box = Hive.openBox('datamesi');


    controller.addListener(() {
      current =controller.page.round();
      onpage();
    });
    datapre =new DateTime(datapre.year-1,);
    datadop =new DateTime(datadop.year+1,);
  }

  void onpage() {
    if (controller.offset <= controller.position.minScrollExtent + 5 &&
        current == 0) {
      setState(() {
        datapre = new DateTime(datapre.year - 1,);
        data = new DateTime(data.year - 1,);
        datadop = new DateTime(datadop.year - 1,);
        controller.jumpToPage(1);
      });
    } else if (controller.offset >= controller.position.maxScrollExtent - 5 &&
        current == 2) {
      setState(() {
        datapre = new DateTime(datapre.year + 1,);
        data = new DateTime(data.year + 1,);
        datadop = new DateTime(datadop.year + 1,);
        controller.jumpToPage(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    date= DateFormat(' yyyy',languageCode ).format(data);
    return Scaffold(
      appBar: AppBar(title: Padding(padding: const EdgeInsets.only(left: 10),
        child: Text(date,style: TextStyle(fontSize: 25),),
      ),) ,
      body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/sfo.png'),fit: BoxFit.fill)),
          padding: EdgeInsets.fromLTRB(0,14,0,0),
          child:FutureBuilder (future: box,builder: (context,snapshop){
          if (snapshop.hasData) {
            return PageView(
              controller: controller,
              children: [
                Mesi_0(mesiAnno,datapre,widget.setdata,refresh),
                Mesi_0(mesiAnno,data,widget.setdata,refresh),
                Mesi_0(mesiAnno,datadop,widget.setdata,refresh)
              ],

            );
           }else return Container();
          }
        ),
      ),

      bottomNavigationBar: Container(
        height: 60,
        color: Colors.grey[200],
        child: FutureBuilder (future: box,builder: (context,snapshop){
          if(snapshop.hasData){
            return Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 20),
                    child: Text('Lavorato: ',style: TextStyle(fontSize: 18),)),
                Text(totaleLavorato(),style: TextStyle(fontSize: 25)),
              ],
            );
          }else return Container();
        }),
      ),
    );
  }
 totaleLavorato(){

    var box = Hive.box('datamesi');
    int ora,min;
    String totaleS;
    int oraT = 0;
    int minT = 0;
    for (int i=0;i<12;i++){
      var dati = box.get(mesiAnno[i]+date) as Mesi;
      if (dati != null) {
        ora = int.parse(dati.lavorato.substring(0,2));
        min = int.parse(dati.lavorato.substring(3,5));
        oraT=oraT+ora;
        minT=minT+min;
      }
    }
    if (minT >= 60) {
      double z = ((minT.toDouble()) / 60.0) + (oraT.toDouble());
      double v = (z - (( z.toInt())).toDouble()) * 60.0;
      oraT = z.toInt();
      minT = v.toInt();
    }
    totaleS=zeroTime(oraT, minT);
    return totaleS;



 }
  String zeroTime(int ora,int min){
    String o,m;
    if (ora.toString().length== 1)  o = "0"+ora.toString();
    else o = ora.toString();
    if (min.toString().length== 1)  m = "0"+min.toString();
    else m = min.toString();
    return o+":"+m;
  }
  refresh(){
    setState(() {

    });
  }
}