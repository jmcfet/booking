import 'dart:ui';
import 'package:flutter/material.dart';
import 'globals.dart';


//  this is the Hour Column that will show the Hour in Large font and
//  half hour in small
Widget ProduceTimeCell(int row) {
  String textToDisplay = "30  ";
  String nameField = ' ';
  double fontSize = 30;
  var color = Colors.black38;

  //this is the hour column
  if (row == Globals.halfHourRow) {
    Globals.halfHourRow += 4;
    fontSize = 20;
  } else {
    if (Globals.hourrow != row) {
      //    Globals.hourrow += 4;
      return Container(
        width: 100,
        height: 60,
        color: Colors.white,
      );
    }
    Globals.hourrow += 4;
    textToDisplay = Globals.hour.toString();

    if (Globals.hour == 12)
    {
      Globals.hour = 0;
      color = Colors.black87;
    }
    Globals.hour++;
  }
  var con = new Container(
    width: 100,
    height: 60,
    child: new Text(textToDisplay,
        textAlign: fontSize == 16 ? TextAlign.right : TextAlign.center,
        style: new TextStyle(
          fontSize: fontSize,
          fontFamily: 'Roboto',
          color: color,
        )),
    //  ),
  );
  return con;
}
Widget produceUnitColumn(int row,int col) {
  double fontSize = 30;
  print("produceUnitColumn: $row $col ");

    var con = new Container(
      width: 100,
      height: 60,
      child: new Text(col.toString(),
          textAlign: fontSize == 16 ? TextAlign.right : TextAlign.center,
          style: new TextStyle(
            fontSize: fontSize,
            fontFamily: 'Roboto',
            color: new Color(0xFF26C6DA),
          )),

    );
    return con;

}
