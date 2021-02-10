


import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' ;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class GoogleAuthClient extends http.BaseClient {
 final Map<String, String> _headers;
 final http.Client _client = new http.Client();
 GoogleAuthClient(this._headers);
 Future<http.StreamedResponse> send(http.BaseRequest request) {
  return _client.send(request..headers.addAll(_headers));
 }
}
class MyDrive {

  GoogleSignInAccount account;
  MyDrive(this.account);




  Future <void> backupApp() async {

  print("User account $account");

  final authHeaders = await account.authHeaders;
  final authenticateClient = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);



 var directory = ( await getApplicationDocumentsDirectory()).path;
 drive.File fileUpmesi = drive.File();
 var filemesi = File('$directory/datamesi.hive');
 fileUpmesi.name = path.basename(filemesi.absolute.path);
 drive.File fileUpbase = drive.File();
 var filebase = File('$directory/database.hive');
 fileUpbase.name = path.basename(filebase.absolute.path);


 var listmesi = await driveApi.files.list(q: "name = 'datamesi.hive'");
 var listbase = await driveApi.files.list(q: "name = 'database.hive'");
 if (listmesi.files.length != 0 ){
   listmesi.files.forEach((element) async{
       await driveApi.files.update(fileUpmesi, element.id,uploadMedia: drive.Media(filemesi.openRead(),filemesi.lengthSync()));
   });

 }else{
   await driveApi.files.create(fileUpmesi,uploadMedia: drive.Media(filemesi.openRead(), filemesi.lengthSync()),);

 }
  if (listbase.files.length != 0 ){
    listbase.files.forEach((element) async{
      await driveApi.files.update(fileUpbase, element.id,uploadMedia: drive.Media(filebase.openRead(),filebase.lengthSync()));
    });

  }else{
    await driveApi.files.create(fileUpbase,uploadMedia: drive.Media(filebase.openRead(), filebase.lengthSync()),);

  }




 }
 Future <Data> listBackup() async{
   final authHeaders = await account.authHeaders;
   final authenticateClient = GoogleAuthClient(authHeaders);
   final driveApi = drive.DriveApi(authenticateClient);
   var list = await driveApi.files.list(q: "name = 'datamesi.hive'");
   var list2= await driveApi.files.list(q: "name = 'database.hive'");
   String mesiid,baseid;
   drive.RevisionList mesirev,baserev;
   if (list.files.length != 0 ){
     list.files.forEach((element1) async{
       mesiid = element1.id;

     });
   }
   if (list2.files.length != 0 ){
     list2.files.forEach((element2) async{
       baseid = element2.id;

     });
   }
   if (mesiid != null)  mesirev = await driveApi.revisions.list(mesiid);
   if (baseid != null)  baserev = await driveApi.revisions.list(baseid);


   return Data(mesiid,baseid,mesirev,baserev);
 }
 Future <String> ripristino(mesiid,baseid,mesirevid,baserevid) async{


   final authHeaders = await account.authHeaders;
   final authenticateClient = GoogleAuthClient(authHeaders);
   final driveApi = drive.DriveApi(authenticateClient);

   drive.Media drivemesi = await driveApi.revisions.get(mesiid,mesirevid,downloadOptions: drive.DownloadOptions.FullMedia);
   drive.Media drivebase = await driveApi.revisions.get(baseid,baserevid,downloadOptions: drive.DownloadOptions.FullMedia);
   var directory = ( await getApplicationDocumentsDirectory()).path;

   Future <bool> list1() async{
     try {
       List<int> data1 = [];
       drivemesi.stream.forEach((element) {
         data1.insertAll(data1.length, element);
       });
       var filemesi = File('$directory/datamesi.hive');
       filemesi.writeAsBytes(data1);
       print('r1 ok');
       return Future.value(true);
     }
     catch(error){
       print('errroree');
       return Future.error(error);
     }

   }
   Future <bool> list2() async{
     List<int> data2 = [];
     try {
       drivebase.stream.forEach((element) {
         data2.insertAll(data2.length, element);
       });
       var filebase = File('$directory/database.hive');
       filebase.writeAsBytes(data2);
       print('r2 ok');
       return Future.value(true);
     }catch(error){
       print(error);
       return Future.error(error);
     }
   }
  return  Future.wait([list1(),list2()]).then((value) {
     print (value);
      return 'ok';
  }).catchError((e){
    return 'err';
  });
 }
 Future<String> elimina(mesiid,baseid,mesirevid,baserevid) async{
   final authHeaders = await account.authHeaders;
   final authenticateClient = GoogleAuthClient(authHeaders);
   final driveApi = drive.DriveApi(authenticateClient);
   await driveApi.revisions.delete(mesiid, mesirevid);
   await driveApi.revisions.delete(baseid, baserevid);
   return Future.value('ok');
 }

}
class Data {
  String mesiid,baseid;
  drive.RevisionList mesirev,baserev;

  Data(this.mesiid, this.baseid, this.mesirev, this.baserev);
}