import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ios_agenda_ore/opzioni.dart';

import 'anno.dart';
import 'main.dart';

class AppDrawer extends StatelessWidget {
  Function setdata;
  AppDrawer(this.setdata);

  @override
  Widget build(BuildContext context) {
   return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/drawer_icon.png'),fit: BoxFit.fill)),
          ),
          ListTile(contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: Text('Mese',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: Text('Anno',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) => Anno(setdata)));
            },
          ),
          ListTile(contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: Text('Opzioni',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) => Opzioni()));
            },
          ),
          ListTile(contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: Text('info',style: TextStyle(fontSize: 20),),
            onTap: () {

            },
          ),
        ],
      ),
   );
  }


}