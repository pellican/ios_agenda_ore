import 'package:in_date_utils/in_date_utils.dart' as DateUtils;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import 'dart:ui' as ui;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:ios_agenda_ore/anno.dart';
import 'package:ios_agenda_ore/database/datamesi.dart';

import 'package:ios_agenda_ore/database/giornate.dart';
import 'package:ios_agenda_ore/drawer.dart';
import 'package:ios_agenda_ore/util/funzioni.dart';
import 'package:path_provider/path_provider.dart';

import 'calendario_0.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();

  // We initialize Hive and we give him the current path
  Hive..init(appDocDir.path)..registerAdapter(GiornateAdapter());
  Hive..init(appDocDir.path)..registerAdapter(MesiAdapter());


  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('it', 'IT'),Locale('en','UK')],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: Locale('it', 'IT'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      title: 'ios Agenda ore',
      theme: ThemeData(

        primaryColor: Colors.grey[200],
        primaryColorLight: Colors.black,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),


      home:  MyHomePage(),


    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime currentBackPressTime;
  DateTime data = DateTime.now();
  DateTime datapre = DateTime.now();
  DateTime datadop = DateTime.now();
  String languageCode = ui.window.locale.languageCode;
  int current;
  String date;
  int oraT ;
  int minT ;
  PageController controller =PageController(initialPage: 1,keepPage: false);
  var box;
  Future<void> _initAdMob() {
    WidgetsFlutterBinding.ensureInitialized();
    Admob.initialize();
  }
  @override
  void initState() {
    box = Hive.openBox('database',compactionStrategy: (entries, deletedEntries) =>  deletedEntries > 20);
    Hive.openBox('datamesi',compactionStrategy: (entries, deletedEntries) =>  deletedEntries > 20);

    controller.addListener(() {
        current =controller.page.round();
        onpage();
    });
    data = new DateTime(data.year,data.month,2);
    datapre =new DateTime(datapre.year,(datapre.month -1),2);
    datadop =new DateTime(datadop.year,(datadop.month +1),2);
    initializeDateFormatting(languageCode);
    _initAdMob();

    super.initState();
  }

  @override
  void dispose() {

    controller.dispose();

    Hive.box('database').compact();
    Hive.box('datamesi').compact();

    Hive.close();
    super.dispose();
  }
 void onpage(){

   if (controller.offset <= controller.position.minScrollExtent +5 &&
        current == 0){
     setState(() {
     datapre =new DateTime(datapre.year,(datapre.month -1),2);
     data =new DateTime(data.year,(data.month -1),2);
     datadop =new DateTime(datadop.year,(datadop.month -1),2);
     controller.jumpToPage(1);
     });
   }else if (controller.offset >= controller.position.maxScrollExtent -5 &&
      current == 2){
     setState(() {
     datapre =new DateTime(datapre.year,(datapre.month +1),2);
     data =new DateTime(data.year,(data.month +1),2);
     datadop =new DateTime(datadop.year,(datadop.month +1),2);
     controller.jumpToPage(1);
     });
   }


 }


  @override
  Widget build(BuildContext context) {


    date= DateFormat('MMMM yyyy',languageCode ).format(data);
    date = date[0].toUpperCase() + date.substring(1);
    return Scaffold(
      appBar: AppBar(

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(date),
        actions: [
          IconButton(alignment: Alignment.centerRight,padding: EdgeInsets.only(right: 20),icon:Icon( Icons.calendar_today,size: 30,), onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => Anno(setData)));
          })
        ],
      ),
      drawer: AppDrawer(setData,refresh),
      body: WillPopScope(onWillPop: onWillPop,
        child: Container(
              child: Column(
                children: [
                  Container(
                    height: 35,
                    color: Colors.grey[100],
                    padding: EdgeInsets.fromLTRB(23, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("lun",style: TextStyle(fontSize: 18)).tr(),
                          Text("mar",style: TextStyle(fontSize: 18)).tr(),
                          Text("mer",style: TextStyle(fontSize: 18)).tr(),
                          Text("gio",style: TextStyle(fontSize: 18)).tr(),
                          Text("ven",style: TextStyle(fontSize: 18)).tr(),
                          Text("sab",style: TextStyle(fontSize: 18)).tr(),
                          Text("dom",style: TextStyle(fontSize: 18)).tr()
                        ],
                      ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/sfo.png'),fit: BoxFit.fill)),
                      padding: EdgeInsets.fromLTRB(0,14,0,0),
                      child:FutureBuilder (future: box,builder: (context,snapshop){
                        if (snapshop.hasData) {
                          return PageView(

                            controller: controller,
                            //  onPageChanged: onpage,

                            children: [
                              Calendario0(datapre, giorni(datapre),onGoBack),
                              Calendario0(data, giorni(data),onGoBack),
                              Calendario0(datadop, giorni(datadop),onGoBack)
                            ],
                            pageSnapping: true,


                          );
                        }else return Container();
                        })


                    ),
                  )
                ],
              )

            ),
      ),



      bottomNavigationBar: Container(
        height: 60,
        color: Colors.grey[200],
        child: FutureBuilder (future: box,builder: (context,snapshop){
          if(snapshop.hasData){
            totale();
            return Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 20),
                  child: Text('ore totale',style: TextStyle(fontSize: 18),).tr()),
                Text(zeroTime(oraT, minT),style: TextStyle(fontSize: 25)),
              ],
            );
          }else return Container();
      }),
      ),
    );
  }
  giorni (DateTime data) {
    var days;

    int lastDay = DateUtils.DateUtils
        .lastDayOfMonth(data)
        .day;
    int firstDay = data.weekday;
    if (firstDay == 1) {
      days = new List(lastDay + (1 * 6));
    }
    else {
      days = new List(lastDay + firstDay - (1 + 1));
    }
    int j = 1;
    if (firstDay > 1) {
      for (j = 0; j < firstDay - 1; j++) {
        days[j] = "";
      }
    }
    else {
      for (j = 0; j < 1 * 6; j++) {
        days[j] = "";
      }
      j = 1 * 6 + 1; // sunday => 1, monday => 7
    }
    int dayNumber = 1;
    for (int i = j - 1; i < days.length; i++) {
      days[i] = dayNumber.toString();
      dayNumber++;
    }
    return days;
  }
  totale() {
    var box = Hive.box('database');
    int ora,min;

    oraT = 0;
    minT = 0;
    for (int i=1;i<32;i++){
      var orai = box.get(i.toString()+' ' + date) as Giornate;
      if (orai != null) {
        ora = int.parse(orai.totale.substring(0,2));
        min = int.parse(orai.totale.substring(3,5));
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

  }

  onGoBack() {
    totale();
    var setmesi = Hive.box('datamesi');
    var smesi = setmesi.get(date) as Mesi;
    if (smesi == null) {
    setmesi.put(date, Mesi(data.year.toString(), oraT,minT, '0', '0'));
    }
    else {
    smesi.ore = oraT;
    smesi.min = minT;
    smesi.pagato = '0';
    smesi.resto = '0';
    smesi.save();
    }
    setState(() {});
  }

  setData(DateTime date){
    setState(() {
      data = new DateTime(date.year,date.month,2);
      datapre =new DateTime(date.year,(date.month -1),2);
      datadop =new DateTime(date.year,(date.month +1),2);
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Premi di nuovo per uscire".tr());
      setData(DateTime.now());
      return Future.value(false);
    }
    return Future.value(true);
  }
   refresh() {

     Hive.close().then((value) {
       box =  Hive.openBox('database',compactionStrategy: (entries, deletedEntries) =>  deletedEntries > 20);
       Hive.openBox('datamesi',compactionStrategy: (entries, deletedEntries) =>  deletedEntries > 20);

       Future.delayed(Duration(seconds: 1),()=>  setState(() {Navigator.pop(context);}));
     });

  }
}