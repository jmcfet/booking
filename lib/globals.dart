import 'package:flutterapp/ProduceNormalCell.dart';

import 'BU.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
class Globals {

  static int  count  = 0;
  static int countperColumn=0;
  static int hour;
  static int halfHourRow = 3;
  static int hourrow = 1;
  static int numBooked;
  static int high;
  static int activeBU;
  static bool editingstate = false;
  static BU selectedBU;
  static BU lastCreatedBU;
  static int butrow = -1;
  static List<MyCell> cellsinUse = new List<MyCell>();

}