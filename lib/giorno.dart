
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ios_agenda_ore/ad_manager.dart';

import 'package:ios_agenda_ore/database/giornate.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class Giorno extends StatefulWidget {
  Function goback;
  final String data;
  Giorno(this.data,this.goback);


  @override
  _Giorno createState() => _Giorno();
}

class _Giorno extends State<Giorno>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String inizio,pause1,finmat,inizpom,pause2,fine;
  int orain=0,minin=0,orpaM=0,mipaM=0,oraFiM=0,minFiM=0;
  int oraInP=0,minInP=0,orapaP=0,minpaP=0,oraFin=0,minFin=0;
  int oratotM=0,mintotM=0,oratotP=0,mintotP=0,oraT=0,minT=0;
  bool errore = false;
  bool salvato = false;
  bool iz=false,p1=false,fm=false,ip=false,p2=false,fi=false;
  var banner;
  var box =Hive.box('database');


  @override
  void initState() {
    String z = "00:00";
    inizio=z;pause1=z;finmat=z;inizpom=z;pause2=z;fine=z;
    var orai= box.get(widget.data) as Giornate;


        setState(() {
          if (orai == null){
            salvato=false;
          }else { salvato=true;
          iz=true;p1=true;fm=true;ip=true;p2=true;fi=true;
          Fluttertoast.showToast(
              msg: "Gia Salvato",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 16.0
          );
            inizio= orai.inizio;orain=int.parse(inizio.substring(0,2));minin=int.parse(inizio.substring(3,5));
            pause1= orai.pausa_m;orpaM=int.parse(pause1.substring(0,2));mipaM=int.parse(pause1.substring(3,5));
            finmat= orai.fine_m;oraFiM=int.parse(finmat.substring(0,2));minFiM=int.parse(finmat.substring(3,5));
            inizpom= orai.inizio_p;oraInP=int.parse(inizpom.substring(0,2));minInP=int.parse(inizpom.substring(3,5));
            pause2= orai.pausa_p;orapaP=int.parse(pause2.substring(0,2));minpaP=int.parse(pause2.substring(3,5));
            fine= orai.fine;oraFin=int.parse(fine.substring(0,2));minFin=int.parse(fine.substring(3,5));
            totale();
          }
        });


    banner= AdmobBanner(
    adUnitId: AdManager.bannerAdUnitId,
    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,);


  }



  void popup (Offset offset,String tag) async{
    SharedPreferences prefs = await _prefs;
    List<String> set = prefs.getStringList(tag) ?? ["00:00","00:00"];
    int min = 0;
    int ore = 0;
    double top = offset.dy;
    double right = offset.dx;
    bool se= true;

   await showMenu(context: context, position: RelativeRect.fromLTRB(0, top, right, 0),
      items: [
        PopupMenuItem(
          enabled: false,
          child: StatefulBuilder (builder:(context,setStato) {
            NumberPicker orePicker = new NumberPicker.integer(initialValue: ore, minValue: 0, maxValue: 24,step: 1,zeroPad: true,
              listViewWidth: 50,onChanged: (vore) => setStato(() => ore = vore),infiniteLoop: true,);
            NumberPicker minPicker = new NumberPicker.integer(initialValue: min, minValue: 0, maxValue: 45,step: 15,zeroPad: true,
              listViewWidth: 50,onChanged: (vmin) => setStato(() => min = vmin),infiniteLoop: true,);
            return Column(
              children: [

                Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(set[0], style: TextStyle(fontSize: 25,color: Colors.black)),
                          ),onTap: (){
                            setStato(() {
                              orePicker.animateInt(int.parse(set[0].substring(0,2)));
                              minPicker.animateInt(int.parse(set[0].substring(3,5)));
                            });
                        },
                        ),
                        Padding(padding: EdgeInsets.only(top: 20),),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(set[1], style: TextStyle(fontSize: 25,color: Colors.black)),
                          ),onTap: (){
                          setStato(() {
                            orePicker.animateInt(int.parse(set[1].substring(0,2)));
                            minPicker.animateInt(int.parse(set[1].substring(3,5)));
                          });
                        },
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 30),),
                    Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('images/spinner.png'), fit: BoxFit.fill)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            orePicker,
                            Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Text(":",style: TextStyle(fontSize: 20),),),
                            minPicker,
                          ],
                        )
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonTheme(
                      height: 50,
                      minWidth: 80,
                      child: RaisedButton(padding: EdgeInsets.all(0.0),
                        child: Text('Setta', style: TextStyle(fontSize: 18),).tr(),
                        color: Colors.blueGrey[200],
                        onPressed: () {
                          setStato ((){
                            if (se){
                              set[0]= zeroTime(ore, min);
                              se=false;
                              prefs.setStringList(tag, set);
                            }else if (!se){
                              set[1]= zeroTime(ore, min);
                              se=true;
                              prefs.setStringList(tag, set);
                            }
                          });

                        },),
                    ),

                    ButtonTheme(
                      height: 50,
                      minWidth: 80,
                      child: RaisedButton(padding: EdgeInsets.all(0.0),
                        child: Text('Annulla', style: TextStyle(fontSize: 18)).tr(),
                        color: Colors.blueGrey[200],
                        onPressed: () {
                          Navigator.pop(context);
                        },),
                    ),

                    ButtonTheme(
                      height: 50,
                      minWidth: 80,
                      child: RaisedButton(padding: EdgeInsets.all(0.0),
                        child: Text('Ok', style: TextStyle(fontSize: 18),),
                        onPressed: () {
                            setState(() {
                              if (tag=="inizio"){inizio=zeroTime(ore, min);orain=ore;minin=min;iz=true;}
                              else if (tag=="finmat"){finmat=zeroTime(ore, min);oraFiM=ore;minFiM=min;fm=true;}
                              else if (tag=="inizpom"){inizpom=zeroTime(ore, min);oraInP=ore;minInP=min;ip=true;}
                              else if (tag=="fine"){fine=zeroTime(ore, min);oraFin=ore;minFin=min;fi=true;}
                              totale();
                            });
                            Navigator.pop(context);
                        },),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
      ]);
}



  void popupPause (Offset offset,String tag) async{
   int min = 0;
   int ore = 0;
  double left = offset.dx;
  double top = offset.dy;
  await showMenu(context: context, position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          enabled: false,
          child: StatefulBuilder (builder:(context,setStato) {
            NumberPicker orePicker = new NumberPicker.integer(initialValue: ore, minValue: 0, maxValue: 24,step: 1,zeroPad: true,
              listViewWidth: 50,onChanged: (vore) => setStato(() => ore = vore),infiniteLoop: true,);
            NumberPicker minPicker = new NumberPicker.integer(initialValue: min, minValue: 0, maxValue: 45,step: 15,zeroPad: true,
              listViewWidth: 50,onChanged: (vmin) => setStato(() => min = vmin),infiniteLoop: true,);
                return Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            ButtonTheme(
                              height: 50,
                              minWidth: 80,
                              child: RaisedButton(padding: EdgeInsets.all(0.0),
                                child: Text('15 min', style: TextStyle(
                                    fontSize: 18)),
                                color: Colors.blueGrey[200],
                                onPressed: () {
                                  setStato(() {
                                  min=15;
                                  minPicker.animateInt(min);
                                  orePicker.animateInt(0);
                                  });
                                },),
                            ),
                            Padding(padding: EdgeInsets.only(top: 15),),
                            ButtonTheme(
                              height: 50,
                              minWidth: 80,
                              child: RaisedButton(padding: EdgeInsets.all(0.0),
                                child: Text('30 min', style: TextStyle(
                                    fontSize: 18)),
                                color: Colors.blueGrey[200],
                                onPressed: () {
                                  setStato(() {
                                    min=30;
                                    minPicker.animateInt(min);
                                    orePicker.animateInt(0);
                                  });
                                },),
                            ),
                            Padding(padding: EdgeInsets.only(top: 15),),
                            ButtonTheme(
                              height: 50,
                              minWidth: 80,
                              child: RaisedButton(padding: EdgeInsets.all(0.0),
                                child: Text('45 min', style: TextStyle(
                                    fontSize: 18)),
                                color: Colors.blueGrey[200],
                                onPressed: () {
                                  setStato(() {
                                    min=45;
                                    minPicker.animateInt(min);
                                    orePicker.animateInt(0);
                                  });
                                },),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(left: 35),),
                        Container(
                            decoration: BoxDecoration(image: DecorationImage(
                                image: AssetImage('images/spinner.png'),
                                fit: BoxFit.fill)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                orePicker,
                                Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Text(":",style: TextStyle(fontSize: 20),),),
                                minPicker,
                              ],
                            )
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonTheme(
                          height: 50,
                          minWidth: 80,
                          child: RaisedButton(padding: EdgeInsets.all(0.0),
                            child: Text('Annulla', style: TextStyle(fontSize: 18)).tr(),
                            color: Colors.blueGrey[200],
                            onPressed: () {
                              Navigator.pop(context);
                            },),
                        ),
                        Padding(padding: EdgeInsets.only(left: 5),),
                        ButtonTheme(
                          height: 50,
                          minWidth: 80,
                          child: RaisedButton(padding: EdgeInsets.all(0.0),
                            child: Text('Ok', style: TextStyle(fontSize: 18),),
                            onPressed: () {
                            setState((){
                              if (tag == "pause1") {
                                p1=true;
                                pause1 = zeroTime(ore, min);
                                orpaM = ore;mipaM = min;
                              }
                              else {
                                p2=true;
                                pause2 = zeroTime(ore, min);
                                orapaP= ore;minpaP=min;
                              }
                              totale();
                            });
                            Navigator.pop(context);
                            },),
                        ),
                      ],
                    )
                  ],
                );
              })
        )]
    );
}


  @override
  Widget build(BuildContext context) {
   // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Hero(
      tag: widget.data,

      child: Scaffold(
       // key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.data),
          centerTitle: true,
          actions: <Widget>[
            IconButton( icon: salvato ? Icon(Icons.delete,size: 35):Icon(null),onPressed: (){
              showDialog(context: context,builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Vuoi Eliminare !'),
                  content: Text(widget.data),
                  actions: [
                    TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          box.delete(widget.data);
                          widget.goback();
                          Navigator.of(context).popUntil((route) => route.isFirst);

                        })
                  ],
                );
              });
            },)
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: Colors.blueGrey[100],
                padding: EdgeInsets.fromLTRB(30,0,30,20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ora Inizio:',style: TextStyle(fontSize: 20)).tr(),
                              GestureDetector(
                                onTapDown: (TapDownDetails detail){
                                 if (!salvato) popup(detail.globalPosition,'inizio');
                                },
                                child:Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:  Text(inizio,style: TextStyle(fontSize: 25,color: iz ?Colors.black:Colors.grey)),
                                ),
                              ),


                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 50),),
                              Text('Pause:',style: TextStyle(fontSize: 20)).tr(),
                              GestureDetector(
                                onTapDown: (TapDownDetails detail){
                                  if (!salvato) popupPause(detail.globalPosition,'pause1');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:  Text(pause1,style: TextStyle(fontSize: 25,color: p1 ?Colors.black:Colors.grey)),
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 50)),
                          Text('Fine Mattino:',style: TextStyle(fontSize: 20)).tr(),

                          GestureDetector(
                              onTapDown: (TapDownDetails detail){
                                if (!salvato) popup(detail.globalPosition,'finmat');
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: errore ?  Border.all(width: 2,color: Colors.red):Border.all(width: 2,color: Colors.blueGrey[100]),
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:  Text(finmat,style: TextStyle(fontSize: 25,color: fm ?Colors.black:Colors.grey))
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
                color: Colors.blueGrey[50],
              ),
              Container(
                color: Colors.blueGrey[100],
                padding: EdgeInsets.fromLTRB(30,0,30,20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Inizio Pomerigio:',style: TextStyle(fontSize: 20)).tr(),
                              GestureDetector(
                                  onTapDown: (TapDownDetails detail){
                                    if (!salvato) popup(detail.globalPosition,'inizpom');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:  Text(inizpom,style: TextStyle(fontSize: 25,color: ip ?Colors.black:Colors.grey)),
                                ),
                              )

                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 50),),
                              Text('Pause:',style: TextStyle(fontSize: 20)).tr(),
                              GestureDetector(
                                  onTapDown: (TapDownDetails detail){
                                    if (!salvato) popupPause(detail.globalPosition,'pause2');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:  Text(pause2,style: TextStyle(fontSize: 25,color: p2 ?Colors.black:Colors.grey)),
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 50),),
                          Text('Fine Lavoro: ',style: TextStyle(fontSize: 20)).tr(),
                          GestureDetector(
                              onTapDown: (TapDownDetails detail){
                                if (!salvato) popup(detail.globalPosition,'fine');
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: errore ? Border.all(width: 2,color: Colors.red):Border.all(width: 2,color: Colors.blueGrey[100]),
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:  Text(fine,style: TextStyle(fontSize: 25,color: fi ?Colors.black:Colors.grey)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 260,
                width: double.infinity,
                color: Colors.blueGrey[50],
                child: FutureBuilder (future: callAsync(),builder: (context,snapshop){
                  if (snapshop.hasData){
                    return banner;
                  } else return Container();

                },

                ),

                ),

            ],
          ),
        ),

        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 6.0,offset: const Offset(0.0, 1.0))]
          ),child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Padding(padding: EdgeInsets.only(left: 40),child: Text(errore ? zeroTime(0,0):zeroTime(oraT, minT),style: TextStyle(fontSize: 25)),)),
              Padding(padding: EdgeInsets.only(right: 20),child:IconButton(icon: salvato ? Icon(Icons.mode_edit):Icon(Icons.save),iconSize: 45,
                 onPressed: () {
                    if (salvato){
                      Fluttertoast.showToast(
                          msg: "Modifica".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey[200],
                          textColor: Colors.black,
                          fontSize: 16.0
                      );
                      setState(() {
                        salvato=false;
                      });
                  }else {
                      if (errore) {
                      showDialog(context: context,builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Errore !').tr(),
                          content: Text('Controlla i Dati').tr(),
                          actions: [
                            TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                            Navigator.of(context).pop();
                            })
                          ],
                        );
                      });

                      }else conferma();
                    }
              },),)
          ],
        ),
        ),

      ),
    );

  }

  Future<bool> callAsync() => Future.delayed(Duration(seconds: 1), () =>  true);

  void conferma(){
    showDialog(context: context,builder: (BuildContext context){
      return Dialog(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
          child: Container(
            height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 60,width:double.infinity,
                    decoration: BoxDecoration(color: Colors.blue[300],borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                    child: Center(child: Text(widget.data+' ore: '.tr()+zeroTime(oraT, minT),style: TextStyle(fontSize: 20),))),
                Text('Vuoi Salvare?',style: TextStyle(fontSize: 20),).tr(),
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
                        totale();

                        box.put(widget.data, Giornate(widget.data, zeroTime(orain, minin), zeroTime(orpaM, mipaM), zeroTime(oraFiM, minFiM),
                            zeroTime(oraInP, minInP), zeroTime(orapaP, minpaP), zeroTime(oraFin, minFin), zeroTime(oraT, minT)));
                        widget.goback();
                        Fluttertoast.showToast(
                            msg: "Dati Salvati".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.black,
                            fontSize: 16.0
                        );
                        Navigator.of(context).popUntil((route) => route.isFirst);

                        },
                      ),))

                    ],
                  ),
                )
              ],
              ),

        ),
      );
    });
  }
  String zeroTime(int ora,int min){
    String o,m;
    if (ora.toString().length== 1)  o = "0"+ora.toString();
    else o = ora.toString();
    if (min.toString().length== 1)  m = "0"+min.toString();
    else m = min.toString();
    return o+":"+m;
  }
  void totale(){
    oratotM=(oraFiM-orain)-orpaM;
    mintotM=(minFiM-minin)-mipaM;
    double m =  mintotM.toDouble() / 60.0;
    if (m < 0.0) {
      double a = m + oratotM.toDouble();
      double b = (a - (( a.toInt())).toDouble())* 60.0;
       oratotM = a.toInt();
       mintotM = b.toInt();
    }
    oratotP=(oraFin-oraInP)-orapaP;
    mintotP=(minFin-minInP)-minpaP;
    double p = (mintotP.toDouble()) / 60.0;
    if (p < 0.0) {
      double c = p + (oratotP.toDouble());
      double d = (c - ((c.toInt())).toDouble()) * 60.0;
       oratotP = c.toInt();
       mintotP = d.toInt();
    }
    oraT=oratotM+oratotP;
    minT=mintotM+mintotP;
    if (minT >= 60) {
      double z = ((minT.toDouble()) / 60.0) + (oraT.toDouble());
      double v = (z - (( z.toInt())).toDouble()) * 60.0;
      oraT = z.toInt();
      minT = v.toInt();
    }
    if (oraT <0 || minT <0 ){
      errore=true;
    }else errore=false;
  }
}
