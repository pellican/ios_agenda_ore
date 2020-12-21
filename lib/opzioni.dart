import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Opzioni extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Padding(padding: const EdgeInsets.only(left: 10),
        child: Text('Opzioni',style: TextStyle(fontSize: 25),),
      ),) ,

    );
  }
}