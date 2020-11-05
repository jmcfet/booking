import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'BU.dart';
import 'globals.dart';
import 'be.dart';
import 'package:flutterapp/service/fileops.dart';
import 'dart:convert';



Widget ProduceCell(bool inputMode, int row, int col, List<BU> slots,
    List<BE> BEs,Function refresh,BuildContext context) {
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
  List<BU> BUsinCol = slots.where((item) => item.entity == col).toList();
  //find which BU this row is in . each slot has a range of rows eg 2-7
  for (var BookingUnit in BUsinCol) {
  //  int butrow = BookingUnit.slotNumStart + 4;
    int numSlots =  BookingUnit.numSlots;
    if (row >= BookingUnit.slotNumStart &&
        row < BookingUnit.slotNumStart + numSlots) {
      //find the containing BU for the row
      mycolor = Colors.green;
      if (BookingUnit.type == TypeBooking.Booking ||
          BookingUnit.type == TypeBooking.editing) {
    //    Globals.butrow = BookingUnit.numSlots + 2;
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
       var tt =0;
  }

      }
      break;
    }

  }
//user has tapped on a cell find the Booking Init that it part of
  _onTapDown1(int row, int col) {
   // setState(() {
    BU cell ;
    int currentHour = DateTime.now().hour;
    int nrows = currentHour*4 +1;
 //   if (row < nrows) {
 //     _showDialog(context);
 //     return;
 //   }
    if (Globals.selectedBU != null && Globals.selectedBU.entity != col){
      _showDialog(context,'must select in same column');
      return;
    }
    if (Globals.selectedBU != null && row >= Globals.selectedBU.slotNumStart + 6){
      _showDialog(context,'too long of booking');
      return;
    }
    //look for a existing BU within n of the row in this column tapped

      cell = slots.firstWhere((item) => item.entity == col &&
          row < item.slotNumStart + 6,orElse: () =>null);

      //if there was none found and not in editing mode then create a new BU
      if (cell == null ){
        if ( !Globals.editingstate) {
          Globals.selectedBU  =
          new BU(col, true, TypeBooking.editing, TimeInterval.hour, row, 1);
          Globals.editingstate = true;
          Globals.selectedBU.ids = new List<String>(4);
          for (int ii=0;ii< 4;ii++)
            Globals.selectedBU.ids[ii] = '';

          
          //   cell = new BU(
          //          col, false, TypeBooking.Booking, TimeInterval.hour, lowrange, BEs[col].numSlots);
          slots.add(Globals.selectedBU );
        }
        else   //TODO  add a dialog
          return;

      }
       else { //we are editting an existing BU
          cell.numSlots = row -  cell.slotNumStart;
          cell.numSlots++;
      }
      refresh();
  //  });
  }
  _saveNames(BU selectedUnit) {
 //   setState(() {
      selectedUnit.type = TypeBooking.Booked;
      selectedUnit.bookingStart = DateTime.now().millisecondsSinceEpoch; // Convert DateTime into timestamp so it can be stored into firebase document
      Globals.selectedBU = null;
      FileService fileservice = new FileService();
      fileservice.saveBUs(jsonEncode(slots));
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
  final myController = TextEditingController();
  myController.text = nameField;


  var con;

  if (inputMode) {
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
            ?
        SimpleAutoCompleteTextField(
          key: key,
          decoration: InputDecoration(
            fillColor: mycolor,
            //      filled: true,
            border: OutlineInputBorder(),

          ),
          controller: myController,
          suggestions: suggestions,
          //       textChanged: (text) => currentText = text,
          clearOnSubmit: true,
          textSubmitted: (text)
          {
                  if (text != "") {
                    Globals.selectedBU.ids[rowinSelectedUnit] = text;
                    refresh();
                  }
                },
        )
            : MaterialButton(
          color: Colors.yellow,
          child: Text('Save'),
          onPressed:
          isSaveEnabled ? () => _saveNames(Globals.selectedBU) : null,
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
  "T-Bone Steak",
  "Urid Dal",
  "Vanilla",
  "Waffles",
  "Yam",
  "Zest"
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