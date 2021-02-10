import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ios_agenda_ore/database/datamesi.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:ios_agenda_ore/mesi_0.dart';
import 'package:ios_agenda_ore/util/funzioni.dart';

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
  String date;
  var box;
  int current;
  TotAnno totAnno;
  PageController controller =PageController(initialPage: 1,keepPage: false);


  @override
  void initState() {
    box = Hive.openBox('datamesi');
    controller.addListener(() {
      current =controller.page.round();
      onpage();
    });
    datapre =new DateTime(datapre.year-1,);
    datadop =new DateTime(datadop.year+1,);
    super.initState();
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
                Mesi_0(datapre,widget.setdata,refresh),
                Mesi_0(data,widget.setdata,refresh),
                Mesi_0(datadop,widget.setdata,refresh)
              ],

            );
           }else return Container();
          }
        ),
      ),

      bottomNavigationBar: InkWell(
        onTap: (){
          dispayBottom(context);
        },
        child: Container(
          height: 60,
          color: Colors.grey[200],
          child: FutureBuilder (future: box,builder: (context,snapshop){
            if(snapshop.hasData){
              totaleLavorato();
              return Padding(padding: const EdgeInsets.only(top: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Lavorato',textAlign: TextAlign.center,style: TextStyle(fontSize: 15),).tr(),
                          Text(totAnno.lavorato,style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Pagato',textAlign: TextAlign.center,style: TextStyle(fontSize: 15),).tr(),
                          Text(totAnno.pagato,style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Resto',textAlign: TextAlign.center,style: TextStyle(fontSize: 15),).tr(),
                          Text(totAnno.resto,style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }else return Container();
          }),
        ),
      ),
    );
  }
  dispayBottom (BuildContext context){
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (ctx){
      return Container(
        height: MediaQuery.of(context).size.height  * 0.35,
        decoration: BoxDecoration(color: Colors.grey[200],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top:20,left: 20,right: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Lavorato',style: TextStyle(fontSize: 18),).tr(),
                      Text(totAnno.lavorato,style: TextStyle(fontSize: 25,color: Colors.grey[700])),
                    ]),
                ),
                Padding(padding: EdgeInsets.only(top:20,left: 20,right: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pagato',style: TextStyle(fontSize: 18),).tr(),
                        Text(totAnno.pagato,style: TextStyle(fontSize: 25,color: Colors.grey[700])),
                      ]),
                ),
                Padding(padding: EdgeInsets.only(top:20,left: 20,right: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Resto',style: TextStyle(fontSize: 18),).tr(),
                        Text(totAnno.resto,style: TextStyle(fontSize: 25,color: Colors.grey[700])),
                      ]),
                ),
                Padding(padding: EdgeInsets.only(top:20,left: 20,right: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Resto Anni Precedenti',style: TextStyle(fontSize: 18),),
                        Text(totAnno.restoAnniP,style: TextStyle(fontSize: 25,color: Colors.grey[700])),
                      ]),
                ),
                Padding(padding: EdgeInsets.only(top:20,left: 20,right: 20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Totale',style: TextStyle(fontSize: 18),),
                        Text(totAnno.totResto,style: TextStyle(fontSize: 25,color: Colors.blue)),
                      ]),
                )

          ]),
        ),

      );
    });
  }

  totaleLavorato(){
    var box = Hive.box('datamesi');
    int ora,min,pag,res;
    String meAnno;
    int oraT = 0;
    int minT = 0;
    int pagT = 0;
    int resT = 0;
    int resAnnT=0;
    String totLavorato;

    for (int i=0;i<12;i++){
      meAnno = DateFormat('MMMM', languageCode).format(new DateTime(0,i + 1));
      meAnno = meAnno[0].toUpperCase() + meAnno.substring(1);
      var datiM = box.get(meAnno + date) as Mesi;
      if (datiM != null) {
        ora = datiM.ore;
        min = datiM.min;
        pag = int.parse(datiM.pagato);
        res = int.parse(datiM.resto);
        pagT=pagT+pag;
        resT=resT+res;
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

    Map<dynamic, dynamic> raw = box.toMap();
    List list = raw.values.toList();
    if (list != null){
      for (int i=0;i<list.length;i++){
        Mesi mesi = list[i];
        int r = int.parse(mesi.resto);
        resAnnT=resAnnT+r;
      }
    }
    totLavorato=zeroTime(oraT, minT);
    int diff= resAnnT-resT;
    totAnno = new TotAnno(totLavorato, pagT.toString(), resT.toString(),diff.toString(), resAnnT.toString());
 }



  refresh(){
    setState(() { });
  }
}
class TotAnno {
  String lavorato;
  String pagato;
  String resto;
  String restoAnniP;
  String totResto;
  TotAnno(this.lavorato, this.pagato, this.resto, this.restoAnniP, this.totResto);
}
