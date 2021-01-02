

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ios_agenda_ore/util/funzioni.dart';
import 'package:ios_agenda_ore/util/heroDialogRoute.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'database/datamesi.dart';


class Mesi_0 extends StatelessWidget{
  Function setdata,refresh;
  DateTime date;

  String anno,meAnno;
  var box =Hive.box('datamesi');
  String languageCode = ui.window.locale.languageCode;
  Mesi_0(this.date,this.setdata,this.refresh);

  @override
  Widget build(BuildContext context) {
    anno = DateFormat(' yyyy', languageCode).format(date);

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
          itemCount: 12,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1),
          itemBuilder: (BuildContext context, int index){
            meAnno = DateFormat('MMMM', languageCode).format(new DateTime(0,index + 1));
            meAnno = meAnno[0].toUpperCase() + meAnno.substring(1);
            var dati = box.get(meAnno + anno) as Mesi;
            return Hero(
              tag: index.toString(),
              child: Material(
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(meAnno, style: TextStyle(fontSize: 20, color: Colors.blue),),
                        Padding(
                          padding:  EdgeInsets.fromLTRB(6,10,6,0),
                          child:
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Lavorato',style: TextStyle(fontSize: 12),).tr(),
                                Text(dati != null ?  Zero.zeroTime(dati.ore, dati.min): '',style: TextStyle(fontSize: 15),)
                              ],
                          )
                        ),
                        Padding(
                            padding:  EdgeInsets.fromLTRB(6,8,6,0),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pagato',style: TextStyle(fontSize: 12),).tr(),
                                Text(dati != null ? dati.pagato : '',style: TextStyle(fontSize: 15),)
                              ],
                            )
                        ),
                        Padding(
                            padding:  EdgeInsets.fromLTRB(6,8,6,0),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Resto',style: TextStyle(fontSize: 12),).tr(),
                                Text(dati != null ? dati.resto : '',style: TextStyle(fontSize: 15),)
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, HeroDialogRoute(builder: (BuildContext context){
                      String mese =DateFormat('MMMM', languageCode).format(new DateTime(0,index + 1));
                      mese = mese[0].toUpperCase() + mese.substring(1);
                      TextEditingController controller = TextEditingController();
                      bool edit= false;
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                        backgroundColor: Colors.transparent,
                        child: Hero(
                          tag: index.toString(),
                          child: StatefulBuilder(builder:(context,setStato) {
                            return Container(
                              height: 400,
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(height: 60,width:double.infinity,
                                    child: Material(color: Colors.blue[300],borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                      child: Padding(padding: const EdgeInsets.only(left: 20,right: 10),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
                                              Expanded(child: Text(mese + anno,style: TextStyle(fontSize: 20,color: Colors.black))),
                                              IconButton(icon: Icon( Icons.calendar_today,size: 30,), onPressed: (){
                                                        setdata(new DateTime(date.year,index+1));
                                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                              })]),
                                      ),
                                    )),
                                  Expanded(
                                    child: Material(
                                      child: Padding( padding: const EdgeInsets.only(left: 20,right: 20),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text('Lavorato',style: TextStyle(fontSize: 20,color: Colors.black)).tr()),
                                            Text(dati != null ? Zero.zeroTime(dati.ore, dati.min) : '',style: TextStyle(fontSize: 20,color: Colors.black),)
                                        ])),
                                    ),
                                  ),
                                  Expanded(
                                    child: Material(
                                      child: Padding( padding: const EdgeInsets.only(left: 20,right: 20),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(child: Text('Pagato',style: TextStyle(fontSize: 20,color: Colors.black)).tr()),
                                                if (!edit && dati != null) IconButton(icon: dati.pagato != '0'? Icon(Icons.clear):Icon(Icons.mode_edit),iconSize: 30 ,onPressed:() {
                                                    setStato((){ edit = true;});
                                                },),
                                                if (edit) Container(width: 60,
                                                  child: TextField(
                                                    controller: controller,
                                                    textAlign: TextAlign.center,
                                                    maxLength: 3,
                                                    autofocus: true,
                                                    style: TextStyle(fontSize: 20,color: Colors.black),
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.digitsOnly
                                                    ],),
                                                )
                                                else Text(dati != null ? dati.pagato : '',style: TextStyle(fontSize: 20,color: Colors.black),),

                                              ])),
                                    ),
                                  ),

                                  Expanded(
                                    child: Material(
                                      child: Padding( padding: const EdgeInsets.only(left: 20,right: 20),
                                       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [Text('Resto',style: TextStyle(fontSize: 20,color: Colors.black)).tr(),
                                          Text(dati != null ? dati.resto : '',style: TextStyle(fontSize: 20,color: Colors.black),)
                                        ],
                                      ),),
                                    ),
                                  ),

                                  Container(height: 60,
                                    decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                                    child: Row(
                                      children: [
                                        Expanded(child:SizedBox.expand(child: RaisedButton(color: Colors.white,shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.only(bottomLeft: Radius.circular(20))),
                                          child:Text('Annulla',style: TextStyle(fontSize: 20)).tr(),
                                          onPressed: (){Navigator.pop(context);},
                                        ),)),
                                        VerticalDivider(color: Colors.grey,width: 2,),
                                        Expanded(child:SizedBox.expand(child: RaisedButton(color: Colors.white,shape: RoundedRectangleBorder(
                                           borderRadius:BorderRadius.only(bottomRight: Radius.circular(20))),
                                          child:Text('Ok',style: TextStyle(fontSize: 20)),
                                          onPressed: (){Navigator.pop(context);
                                           if (controller.text != '' && controller.text != null && dati != null){
                                             int field = int.parse(controller.text);
                                             int lav = dati.ore;
                                             int rest = lav - field ;
                                             dati.pagato = controller.text;
                                             if (field != 0) dati.resto = rest.toString();
                                             else dati.resto = '0';
                                             dati.save();
                                             refresh();
                                           }

                                        },
                                        ),))
                                      ]
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    }));
                  },
                ),
              ),
            );

      }),

    );
  }

}