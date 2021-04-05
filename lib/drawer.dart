import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:ios_agenda_ore/opzioni.dart';
import 'package:easy_localization/easy_localization.dart';
import 'anno.dart';

class AppDrawer extends StatelessWidget {
  Function setdata;
  Function refresh;
  AppDrawer(this.setdata,this.refresh);

  @override
  Widget build(BuildContext context) {
   return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/drawer_icon.png'),fit: BoxFit.fill)),
            child: Container(),
          ),
          ListTile(contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: Text('Mese',style: TextStyle(fontSize: 20),).tr(),
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
            title: Text('Backup',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) => Opzioni(refresh)));
            },
          ),
          ListTile(contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: Text('info',style: TextStyle(fontSize: 20),),
            onTap: () {
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  content: Container(
                    height: 80,
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Agenda ore 3.0.0',style: TextStyle(fontSize: 20,color:Colors.cyan )),
                        Text('@pietro.calleri')
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
   );
  }


}