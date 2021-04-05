import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart' ;

import 'package:googleapis/drive/v3.dart' as drive;


import 'package:ios_agenda_ore/backup/backup.dart';



class Opzioni extends StatefulWidget {
  final Function refresh;
  Opzioni(this.refresh);

  @override
  _Opzioni createState() => _Opzioni();
}

class _Opzioni extends State<Opzioni>{
  String mesiid,baseid;
  bool swiConnetti = false;
  GoogleSignInAccount account;
  GoogleSignIn googleSignIn = GoogleSignIn.standard(scopes: [drive.DriveApi.DriveScope]);
  drive.RevisionList mesirev,baserev;
  bool expanded = false;
  String languageCode = ui.window.locale.languageCode;
  int posB;

  int tim = 0;
  String mess='no';
  Future<String> timer() => Future.delayed(Duration(seconds: tim),() => mess);

  @override
  void initState() {
    checkConnection();

    super.initState();
    }
    void dati() async{
      posB = 0;
      Data data = await MyDrive(account).listBackup();
      mesiid = data.mesiid;
      baseid = data.baseid;
      mesirev = data.mesirev;
      baserev = data.baserev;
      if (baserev != null){
        baserev.revisions = baserev.revisions.reversed.toList();
        mesirev.revisions = mesirev.revisions.reversed.toList();
      }
      setState(() {

      });
    }

   void login() async{

      if (await googleSignIn.isSignedIn() )  {
        account =  await googleSignIn.signInSilently();
        print('signsilent');

      }
      else {
        account = await googleSignIn.signIn();

        print('non sign');
      }
      if (account != null) {
        dati();

        setState(() {
          swiConnetti = true;
          print('swicon'+swiConnetti.toString());
        });
      }
   }
   void logout() async{
    await googleSignIn.signOut();
    setState(() {
      swiConnetti = false;
    });
     print('logout');
   }
   void checkConnection() async{
     try {
       final result = await InternetAddress.lookup('google.com');
       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         Fluttertoast.showToast(
             msg: "Log In".tr(),
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.cyan,
             textColor: Colors.black,
             fontSize: 16.0
         );
         login();
       }
     } on SocketException catch (_) {
       noConn();
     }

   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Padding(padding: const EdgeInsets.only(left: 10),
        child: Text('Backup & Ripristino',style: TextStyle(fontSize: 22),).tr(),
      ),) ,
      body: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:swiConnetti ? NetworkImage(account.photoUrl) : null,
                  child: swiConnetti ? null : Image.asset('images/avatar.png'),
                  backgroundColor: Colors.transparent,
                ),
                Padding(padding: const EdgeInsets.only(top: 15),
                  child: Text(swiConnetti ? account.displayName : 'User',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                ),
                Padding(padding: const EdgeInsets.only(top: 15),
                  child: Text(swiConnetti ? account.email :'Email',style: TextStyle(fontSize: 15),),
                )
              ],
            ),
          ),
          Expanded(child: Container(width: double.infinity,
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 15,left: 15),
                      child: Text('Account',style: TextStyle(fontSize: 18,color: Colors.cyan),),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10),
                      child: SwitchListTile(
                        title: Text(swiConnetti ? 'Disonnetti da Google Drive ':'Connetti a Google Drive') ,
                          value: swiConnetti,
                          onChanged: (value){
                          if (value) checkConnection();
                          else logout();

                      }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10,left: 15,right: 15),
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          onPressed: !swiConnetti ? null :(){
                            showloaddialog();
                            var my = MyDrive(account);
                            my.backupApp()
                                .then((value){
                              Fluttertoast.showToast(
                                  msg: 'Backup con successo',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.black,
                                  fontSize: 16.0
                              );
                              Navigator.pop(context);

                                dati();

                            }).catchError((_){
                                  Navigator.pop(context);
                                  noConn();
                            });
                          },
                          child: Text('Esegui il Backup',style: TextStyle(fontSize: 18),),
                        ),
                      ),),

                    Padding(padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                      child: Text('Backup Effettuato',style: TextStyle(fontSize: 18,color: Colors.cyan),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15,left: 15,right: 15),
                      child: ExpansionPanelList(
                        expansionCallback: (index,isExpanded){
                          setState(() {
                            expanded = !isExpanded;
                          });
                        },

                        children: [
                          ExpansionPanel(canTapOnHeader: true,headerBuilder: (context,isExpand){
                            return InkWell(
                              onTap: (){
                                if (baserev != null){
                                showDialog(context: context,builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Center(child: Text('backup')),
                                      content: Container(
                                        height: 120,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.cloud_queue),
                                                Padding(padding: EdgeInsets.only(left: 10),
                                                 child: Text(baserev != null ? DateFormat('dd MMMM yyyy HH:mm',languageCode )
                                                    .format(baserev.revisions[posB].modifiedTime) : '',style: TextStyle(fontSize: 18),),)
                                              ],),
                                            Padding(padding: const EdgeInsets.only(top: 0),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextButton(onPressed: () {
                                                    showloaddialog();
                                                    var message = MyDrive(account).ripristino(mesiid,baseid,mesirev.revisions[posB].id,baserev.revisions[posB].id);
                                                     message.then((value)  {
                                                       Navigator.pop(context);
                                                       if (value == 'ok'){
                                                         Fluttertoast.showToast(
                                                             msg: 'Ripristinato con successo',
                                                             toastLength: Toast.LENGTH_SHORT,
                                                             gravity: ToastGravity.BOTTOM,
                                                             timeInSecForIosWeb: 1,
                                                             backgroundColor: Colors.green,
                                                             textColor: Colors.black,
                                                             fontSize: 16.0
                                                         );
                                                         widget.refresh();

                                                       }else{
                                                         Fluttertoast.showToast(
                                                             msg: 'Errore nel Ripristino',
                                                             toastLength: Toast.LENGTH_SHORT,
                                                             gravity: ToastGravity.BOTTOM,
                                                             timeInSecForIosWeb: 1,
                                                             backgroundColor: Colors.red,
                                                             textColor: Colors.black,
                                                             fontSize: 16.0
                                                         );
                                                       }
                                                       Navigator.pop(context);
                                                    }).catchError((e){
                                                       Navigator.pop(context);
                                                       noConn();
                                                     });



                                                  },style: TextButton.styleFrom(backgroundColor: Colors.black12 ),
                                                      child: Text('Ripristina',style: TextStyle(fontSize: 15,color: Colors.black),)),
                                                  TextButton(onPressed: (){
                                                    showloaddialog();
                                                     var eli= MyDrive(account).elimina(mesiid, baseid, mesirev.revisions[posB].id,baserev.revisions[posB].id);
                                                     eli.then((value) {
                                                       Navigator.pop(context);
                                                       Fluttertoast.showToast(
                                                           msg: 'Eliminato',
                                                           toastLength: Toast.LENGTH_SHORT,
                                                           gravity: ToastGravity.BOTTOM,
                                                           timeInSecForIosWeb: 1,
                                                           backgroundColor: Colors.red,
                                                           textColor: Colors.black,
                                                           fontSize: 16.0
                                                       );
                                                       Navigator.pop(context);

                                                         dati();

                                                     }).catchError((e){
                                                       Navigator.pop(context);
                                                       noConn();
                                                     });
                                                  },style: TextButton.styleFrom(backgroundColor: Colors.black12 ),
                                                      child: Text('Elimina',style: TextStyle(fontSize: 15,color: Colors.black),))
                                                ],),),

                                          ],
                                        ),
                                      ),
                                      actions: [
                                         TextButton(onPressed: () => Navigator.pop(context),
                                             child: Text('Annulla'))
                                      ],
                                    );

                                 });
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(baserev != null ? DateFormat('dd MMMM yyyy HH:mm',languageCode )
                                      .format(baserev.revisions[posB].modifiedTime) : '',style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            );
                          },
                              body: ListView.builder(
                                  itemCount: baserev != null ? baserev.revisions.length : 0,
                                  shrinkWrap: true,
                                  itemBuilder: (context,index){
                                    return InkWell(
                                      onTap: (){
                                        setState(() {
                                          posB = index;
                                          expanded = false ;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.black12,
                                        padding: const EdgeInsets.all(15),
                                        child: Text(baserev != null ? DateFormat('dd MMMM yyyy HH:mm',languageCode )
                                            .format(baserev.revisions[index].modifiedTime) : '',style: TextStyle(fontSize: 18),),
                                      ),
                                    );
                                  }),
                          isExpanded: expanded
                          )
                        ],

                      ),
                    ),




                  ],
              ),
            ),
          ))
        ],
      ),
    );
  }
  void showloaddialog() {
    showDialog(context: context,builder: (context){
      return AlertDialog(
        content: Container(
          height: 50,
          child: Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

     }
    );
  }
  void noConn(){
    Fluttertoast.showToast(
        msg: "Nessuna Connessione".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey[200],
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}
