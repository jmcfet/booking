import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'BU.dart';
import 'globals.dart';
import 'be.dart';
import 'package:flutterapp/service/fileops.dart';
import 'dart:convert';



Widget ProduceCell(bool inputMode, int row, int col, List<BU> BUs,
    List<BE> BEs,Function refresh,BuildContext context,bool adminmode) {
  List<GlobalKey> keys = new List<GlobalKey>();
  var numRequired = 4;
  double borderwidth = 1;
  Color mycolor = Colors.white;
  Color textColor;
  String label;
  int skipCells = 0;
  inputMode = false;
  bool butcell = false;
  int rowinSelectedUnit = -1;
  bool isSaveEnabled = false;
  String textToDisplay = "30  ";
  String nameField = ' ';
  double fontSize = 30;


  //  col++;
  //  row++;
  BE be = BEs[col];

  //normal column

  mycolor = Colors.green;
  inputMode = false;

  if (row == 1) Globals.numBooked = 0;
  if (col == 3)
    {
      int i =  0;
    }
  List<BU> BUsinCol = BUs.where((item) => item.entity == col).toList();
  //find which BU this row is in . each slot has a range of rows eg 2-7
  for (var BookingUnit in BUsinCol) {
  //  int butrow = BookingUnit.slotNumStart + 4;
    int numBUs =  BookingUnit.numSlots;
    if (row >= BookingUnit.slotNumStart &&
        row < BookingUnit.slotNumStart + numBUs) {
      //find the containing BU for the row
      mycolor = Colors.green;
      if (BookingUnit.type == TypeBooking.Booking ||
          BookingUnit.type == TypeBooking.editing) {
    //    Globals.butrow = BookingUnit.numBUs + 2;
        rowinSelectedUnit = row - BookingUnit.slotNumStart;
        if (rowinSelectedUnit < BookingUnit.ids.length)
            nameField = BookingUnit.ids[rowinSelectedUnit] == null
            ? ' '
            : BookingUnit.ids[rowinSelectedUnit];

        isSaveEnabled = false;
        int icnt = 0;
        BookingUnit.ids.forEach( (value) {
          if (value.length != 0) icnt++;
        });
        if (icnt >= numRequired) isSaveEnabled = true;
        mycolor = Colors.grey;
        inputMode = true;

      }
      if (BookingUnit.type == TypeBooking.Booked) {
        mycolor = Colors.black26;
        if (BookingUnit.selected)
            mycolor = Colors.amberAccent;
        //vary colors for consectively booked units
        if (BookingUnit.slotNumStart == row) Globals.numBooked++;
        if (Globals.numBooked % 2 == 0) {
          mycolor = Colors.black45;
        }
        textColor = Colors.white;
        rowinSelectedUnit = row - BookingUnit.slotNumStart;
        try {
          if (BookingUnit.ids != null &&
              rowinSelectedUnit < BookingUnit.ids.length)
            nameField = BookingUnit.ids[rowinSelectedUnit] == null
                ? ' '
                : BookingUnit.ids[rowinSelectedUnit];
        }catch( e)
        {
            _showDialog(context, e.toString());
        }

      }
      break;
    }

  }
  createnewBU(){
    if (!Globals.editingstate) {
      Globals.UnderConstructionBU =
      new BU(col, true, TypeBooking.editing, TimeInterval.hour, row, 1);
      Globals.editingstate = true;
      Globals.UnderConstructionBU.ids = new List<String>(4);
      for (int ii = 0; ii < 4; ii++)
        Globals.UnderConstructionBU.ids[ii] = '';
      BUs.add(Globals.UnderConstructionBU);
    }
  }
///user has tapped on a cell find the Booking Init that it part of
  _onTapDown1(int row, int col) {
   // setState(() {
    BU bu ;
    int currentHour = DateTime.now().hour;
    int nrows = currentHour*4 +1;
 //   if (row < nrows) {
 //     _showDialog(context);
 //     return;
 //   }
    List<BU> busForCol  = BUs.where((item) => item.entity == col).toList();
    if (Globals.UnderConstructionBU != null && Globals.UnderConstructionBU.entity != col){
      _showDialog(context,'must select in same column');
      return;
    }
    //no BU in this column so create a new one
    if (busForCol.length == 0){
      createnewBU();
      refresh();
      return;
    }
 //   if (Globals.UnderConstructionBU != null && row >= Globals.UnderConstructionBU.slotNumStart + 6 && !adminmode){
///      _showDialog(context,'too long of booking');
 //     return;

//    if tapped an existing BU them mark as selected
    bu = busForCol.firstWhere((item) =>  row  >  item.slotNumStart && row <  item.slotNumStart + item.numSlots,orElse: () =>null);
    if (bu != null){
      bu.selected = true;
    }
    else { //might be extending an existing
// look for a existing BU within n of the row in this column tapped
      bu = busForCol.firstWhere((item) => row  >  item.slotNumStart &&
            row < item.slotNumStart + 6, orElse: () => null);
      //if there was none found and not in editing mode then create a new BU
      if (bu == null) {
        createnewBU();
        refresh();
        return;
      }
      else { //we are editting an existing BU
        bu.numSlots = row - bu.slotNumStart;
        bu.numSlots++;
      }
    }
    refresh();
  //  });
  }

  _saveNames(BU selectedUnit) {
 //   setState(() {
      selectedUnit.type = TypeBooking.Booked;
      selectedUnit.bookingStart = DateTime.now().millisecondsSinceEpoch; // Convert DateTime into timestamp so it can be stored into firebase document
      Globals.UnderConstructionBU = null;
      FileService fileservice = new FileService();
//      fileservice.saveBUs(jsonEncode(BUs));
      refresh();
 //   });
  }
//  if (Globals.editingstate && row == Globals.butrow){
 //       inputMode = true;
 //       butcell = true;
//  }

  int remain = (row) % 4;
  int remain1 = (row + 1) % 7;
  var bottomstyle = remain == 0 ? BorderStyle.solid : BorderStyle.none;
  if (remain1 == 0) {
    bottomstyle = BorderStyle.none;
    borderwidth = 3;
  }
  borderwidth = remain1 == 0 ? 2 : 1;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  keys.add(key);
  var myController = TextEditingController();
  myController.text = nameField;


  var con;

  if (inputMode) {
    var autocomplete = new SimpleAutoCompleteTextField(
      key: new GlobalKey(),
      decoration: InputDecoration(
        fillColor: mycolor,
        //      filled: true,
        border: OutlineInputBorder(),

      ),
      controller: myController,
      suggestions: suggestions,

      clearOnSubmit: false,
      textSubmitted: (text) {
        if (text != "") {
          if (!adminmode){
            if (suggestions.contains(text)){
              var tt = 0;
            }
          }

          Globals.UnderConstructionBU.ids[rowinSelectedUnit] = text;
          refresh();
        }
      },
      onFocusChanged: (text) {

      },
    );
   // Globals.textboxes.add(autocomplete);
    //changes are being made so we need textfields and buttons
    con = Container(
      //draw border
      //  key: key,
        decoration: BoxDecoration(
          //  color: mycolor,
            border: Border(
                right: BorderSide(color: Colors.black, width: 1.0),
                bottom: BorderSide(
                    color: Colors.black,
                    width: borderwidth,
                    style: bottomstyle))),
        width: 150,
        height: 60,
        //child is empty container or a textbox
        child: !butcell
            ? autocomplete
        : MaterialButton(
          color: Colors.yellow,
          child: Text('Save'),
          onPressed:
          isSaveEnabled ? () => _saveNames(Globals.UnderConstructionBU) : null,
        )
    );
  } else
    con = new MyCell(
        row: row,
        col: col,
        onPressed: _onTapDown1,
        labelText: nameField,
        cellColor: mycolor,
        cellStyle: bottomstyle,
        cellTextColor: textColor);

  return con;
}
List<String> suggestions = [
  "mcFetridge john",
  "smith bill",
  "miller joe",
  "barker bill",
  "grossman amy",
  "weiner paul",
  "andrews peter",
  "alberg rich",
  "Blueberry",
  "Cheese",
  "Danish",
  "Eclair",
  "Fudge",
  "Granola",
  "Hazelnut",
  "Ice Cream",
  "Jely",
  "Kiwi Fruit",
  "Lamb",
  "Macadamia",
  "Nachos",
  "Oatmeal",
  "Palm Oil",
  "Quail",
  "Rabbit",
  "Salad",
  "pro",
  "ladies Doubles",
  "Junior Tornament",
  "Club Open",
  "Intermediate",
  "Water"
];
//this was created so we will know the row and column tapped
class MyCell extends StatelessWidget {
  final int row;
  final int col;
  final Function(int, int) onPressed;
  final String labelText;
  final Color cellColor;
  final BorderStyle cellStyle;
  final Color cellTextColor;

  const MyCell(
      {this.row,
        this.col,
        this.onPressed,
        this.labelText,
        this.cellColor,
        this.cellStyle,
        this.cellTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: cellColor,
            border: Border(
                right: BorderSide(color: Colors.black, width: 1.0),
                bottom: BorderSide(
                    color: Colors.black, width: 1, style: cellStyle))),
        width: 150,
        height: 60,
        child: GestureDetector(
          child: Text(labelText, style: TextStyle(color: cellTextColor)),
          onTap: () {
            onPressed(row, col);
          },
        ));
  }
}

void _showDialog(BuildContext context,String msg) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("internal logic error"),
        content: new Text(msg),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}