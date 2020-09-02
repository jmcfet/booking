import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'BU.dart';
import 'globals.dart';
import 'be.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<BU> slots = new List<BU>();
  bool inputMode = true;
  List<BE> BEs = new List<BE>();
  Map reserved = new Map<int, List<int>>();
  int timeRows = 8; //number rows for time e.g 4 hours from 8 to 12
  int court = 0;

  BU selectedBU;
  List<GlobalKey> keys = new List<GlobalKey>();
  List<Offset> bb = List<Offset>();
  MyHomePage() {
    initState();
  }

  void initState() {
    setState(() {
      inputMode = false;
      //  slots.add(new BU(0,true,TypeBooking.Booked,TimeInterval.hour,0,6));
      for (int i = 0; i < 6; i++) {
        int k = i * 6 + 1;
        BU cell1 = new BU(1, true, TypeBooking.Free, TimeInterval.hour, k, 6);
        /*
      cell1.idvalues = {
        0: 'john',
        1: 'bob',
        2: 'dave',
        3: 'dave',
        4: ' ',
        5: ' '
      };
      */

        slots.add(cell1);
      }
      for (int i = 0; i < 6; i++) {
        int k = i * 6 + 1;
        BU cell1 = new BU(2, true, TypeBooking.Free, TimeInterval.hour, k, 6);
        slots.add(cell1);
      }
      for (int i = 0; i < 6; i++) {
        int k = i * 6 + 1;
        BU cell1 = new BU(3, true, TypeBooking.Free, TimeInterval.hour, k, 6);
        slots.add(cell1);
      }
      for (int i = 0; i < 6; i++) {
        int k = i * 6 + 1;
        BU cell1 = new BU(4, true, TypeBooking.Free, TimeInterval.hour, k, 6);
        slots.add(cell1);
      }
      for (int i = 0; i < 6; i++) {
        int k = i * 4 + 2 + 1;
        BU cell1 = new BU(5, true, TypeBooking.Free, TimeInterval.hour, k, 4);
        slots.add(cell1);
      }
      for (int i = 0; i < 6; i++) {
        int k = i * 4 + 2 + 1;
        BU cell1 = new BU(6, true, TypeBooking.Free, TimeInterval.hour, k, 4);
        slots.add(cell1);
      }

      //    reserved = {1:  (1,2,3,4,5,6,10,11)};
      BEs.add(new BE(2, 6)); //col 0 is used for date
      BEs.add(new BE(0, 4));
      BEs.add(new BE(0, 6));
      BEs.add(new BE(0, 6));
      BEs.add(new BE(0, 4));
      BEs.add(new BE(2, 4));
      BEs.add(new BE(2, 6));
      BEs.add(new BE(2, 4));
      BEs.add(new BE(2, 4));
      BEs.add(new BE(0, 6));
      BEs.add(new BE(0, 6));
      BEs.add(new BE(0, 4));
      reserved = new Map<int, List<int>>();
    });
    //   WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _toggleInput() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //    inputMode = !inputMode ;
      inputMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Globals.count = 0;
    Globals.hour = 8;
    Globals.halfHourRow = 3;
    Globals.hourrow = 1;
    //  slots.add(new BU(true,false,TimeInterval.hour,0,6));

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Row(
              children: List.generate(
                BEs.length,
                (col) => Column(
                  children: List.generate(timeRows * 4,
                      (row) => ProduceCell(inputMode, row, col, slots, BEs)),
                ),
              ),
            ),
          ),
        ));
  }

  Widget ProduceCell(
      bool inputMode, int row, int col, List<BU> slots, List<BE> BEs) {
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
    if (col == 0) {
      //this is the hour column
      if (row == Globals.halfHourRow) {
        Globals.halfHourRow += 4;
        fontSize = 16;
      } else {
        //    int remain = (row) % 5;
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
        if (Globals.hour == 12) Globals.hour = 0;
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
              color: new Color(0xFF26C6DA),
            )),
        //  ),
      );
      return con;
    }
    if (row == 0) {
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
        //  ),
      );
      return con;
    }
    //normal column

    mycolor = Colors.green;
    inputMode = false;
    if (row == 1) Globals.numBooked = 0;
    List<BU> BUsinCol = slots.where((item) => item.entity == col).toList();
    //find which BU this row is in . each slot has a range of rows eg 2-7
    for (var BookingUnit in BUsinCol) {
      int butrow = BookingUnit.slotNumStart + 4;
      int numSlots = BookingUnit.type == TypeBooking.editing ? 5 : BookingUnit.numSlots;
      if (row >= BookingUnit.slotNumStart &&
          row < BookingUnit.slotNumStart + numSlots) {
            //find the containing BU for the row
        //    mycolor = Colors.green;
            if (BookingUnit.type == TypeBooking.Booking ||
                BookingUnit.type == TypeBooking.editing) {
              int butrow = BookingUnit.slotNumStart + 4;
              rowinSelectedUnit = row - BookingUnit.slotNumStart;
              nameField = BookingUnit.ids[rowinSelectedUnit] == null
                  ? ' '
                  : BookingUnit.ids[rowinSelectedUnit];

              isSaveEnabled = false;
              int icnt = 0;
              BookingUnit.ids.forEach((key, value) {
                if (value.length != 0) icnt++;
              });
              if (icnt >= numRequired) isSaveEnabled = true;
              mycolor = Colors.grey;
              inputMode = true;
              if (row == butrow) butcell = true;

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
              nameField = BookingUnit.ids[rowinSelectedUnit] == null
                  ? ' '
                  : BookingUnit.ids[rowinSelectedUnit];
            }
            break;
      }
    }

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
    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
      super.dispose();
    }

    var con;

    if (inputMode) {
      //changes are being made so we need textfields and buttons
      con = Container(
          //draw border
        //  key: key,
          decoration: BoxDecoration(
              color: mycolor,
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
              ? /*TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    fillColor: mycolor,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: nameField,
                  ),
                  onSubmitted: (String str) {
                    setState(() {
                      selectedBU.ids[rowinSelectedUnit] = str;
                      print("onSubmitted: $rowinSelectedUnit $str ");
                    });
                  })*/
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
            textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedBU.ids[rowinSelectedUnit] = text;;
              }
            }),
          )
          : MaterialButton(
                  child: Text('Save'),
                  onPressed:
                      isSaveEnabled ? () => _saveNames(selectedBU) : null,
          )
      );
    } else
      con = new FAB1(
          row: row,
          col: col,
          onPressed: _onTapDown1,
          labelText: nameField,
          cellColor: mycolor,
          cellStyle: bottomstyle,
          cellTextColor: textColor);
    return con;
  }

  _saveNames(BU selectedUnit) {
    setState(() {
      selectedUnit.type = TypeBooking.Booked;
      selectedBU = null;
    });
  }

//user has tapped on a cell find the Booking Init that it part of
  _onTapDown1(int row, int col) {
    setState(() {
      List<BU> colSlots = slots.where((item) => item.entity == col).toList();
      //find which slot this row is in . each slot has a range of rows eg 2-7
      colSlots.forEach((element) {
        int butrow = element.slotNumStart + 4;
        if (row >= element.slotNumStart &&
            row < element.slotNumStart + element.numSlots) {
          selectedBU = element;
          selectedBU.type = TypeBooking.editing;
        }
      });
      if (selectedBU == null) {
        AssertionError("cann ot be null");
        //   cell = new BU(
        //          col, false, TypeBooking.Booking, TimeInterval.hour, lowrange, BEs[col].numSlots);
        //      slots.add(cell);
      }
    });
  }

  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset

    print("tap down " + x.toString() + ", " + y.toString());
    int cnt = 0;
    for (var offset in this.bb) {
      if (x >= offset.dx && x < offset.dx + 150) {
        if (y >= offset.dy && y < offset.dy + 60) {
          break;
        }
      }
      cnt++;
    }
    //what are the bookable
    int row = cnt % (timeRows * 4);
    int col = (cnt / (timeRows * 4)).round() + 1;

    print("selected: $cnt $row $col ");

    //   int lowrange =
    //       ((row / BEs[col].numSlots).round() * BEs[col].numSlots) + BEs[col].offsetFirst;
    //   int hirange =
    //       (((row / BEs[col].numSlots).round() + 1) * BEs[col].numSlots) + BEs[col].offsetFirst;
//    print("selected: $cnt $row $col $lowrange $hirange");
    setState(() {
      BU cell;
      List<BU> colSlots = slots.where((item) => item.entity == col).toList();
      //find which slot this row is in . each slot has a range of rows eg 2-7
      colSlots.forEach((element) {
        int butrow = element.slotNumStart + 4;
        if (row >= element.slotNumStart &&
            row < element.slotNumStart + element.numSlots) {
          cell = element;
          cell.type = TypeBooking.editing;
        }
      });
      if (cell == null) {
        AssertionError("cann ot be null");
        //   cell = new BU(
        //          col, false, TypeBooking.Booking, TimeInterval.hour, lowrange, BEs[col].numSlots);
        //      slots.add(cell);
      }
    });
  }
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

class FAB1 extends StatelessWidget {
  final int row;
  final int col;
  final Function(int, int) onPressed;
  final String labelText;
  final Color cellColor;
  final BorderStyle cellStyle;
  final Color cellTextColor;

  const FAB1(
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
