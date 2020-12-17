import 'dart:ui';

import 'package:flutter/material.dart';
import 'BU.dart';
import 'globals.dart';
import 'be.dart';
import 'package:flutterapp/ProduceTimeCell.dart';
import 'package:flutterapp/ProduceNormalCell.dart';
import 'package:flutterapp/service/fileops.dart';
import 'dart:convert';
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
      home: MyHomePage(title: 'wed 20 september'),
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
  List<BU> allbookings = new List<BU>();
  static FileService fileservice = new FileService();
  bool inputMode = true;
  List<BE> BEs = new List<BE>();
  Map reserved = new Map<int, List<int>>();
  int timeRows = 12; //number rows for time e.g 4 hours from 8 to 12
  int court = 0;
  DateTime selectedDate = DateTime.now();
 List<BU> buForToday = new List<BU>() ;
  List<BU> repeatingBUs = new List<BU>() ;
  ScrollController _scrollController ;
  double _ItemHeight = 240;
  List<Offset> bb = List<Offset>();
  int hour;
  List<BU>   myModels;
  int _value = 1;
  bool adminMode = false;


  void initState()  {
    super.initState();
    _scrollController = new ScrollController();
    getBUS();
  }

  getBUS() async {
    String json1 = await fileservice.readBUs();
    inputMode = false;
    try {
      if (json1 != 'err') {
        if (json1.startsWith('[')) { //is this json array?
          allbookings = (json.decode(json1) as List).map((i) =>
              BU.fromJson(i)).toList();
          buForToday = allbookings.where((element) =>
          DateTime
              .fromMillisecondsSinceEpoch(element.bookingStart)
              .day == DateTime
              .now()
              .day).toList();
        }
        else {
          //not a list so treat as a single object
          BU bu = BU.fromJson(json.decode(json1));
          if (DateTime
              .fromMillisecondsSinceEpoch(bu.bookingStart)
              .day == DateTime
              .now()
              .day)
            buForToday.add(bu);
        }
      }

      //get the daily reoccuring
      String json2 = await fileservice.readRepeatingBUs();
      if (json2 != 'err') {
        if (json2.startsWith('[')) {
          repeatingBUs = (json.decode(json2) as List).map((i) =>
              BU.fromJson(i)).toList();
          buForToday.addAll(repeatingBUs);
        }
        else {
          BU repeat = BU.fromJson(json.decode(json2));
          repeatingBUs.add(repeat);
          buForToday.add(repeat);
        }
      }
    }
    catch (e) {
      _showDialog(e.toString());
    }

    setState(() {
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
      // we need aan function to run after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild());
    });

  }


  void _toggleInput() {
    setState(() {

      //    inputMode = !inputMode ;
      //inputMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Globals.count = 0;
    Globals.hour = 8;
    Globals.halfHourRow = 3;
    Globals.hourrow = 1;



    var scaffold = new  Scaffold(
        appBar: AppBar(
          title: Text("Court Master"),
          actions: <Widget>[

            Container(
              child:Column(
                children:[
                  Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children:[
                      IconButton(
                        icon: Icon(Icons.save_alt),
                        tooltip: 'prev',
                        onPressed: () =>  _PrevDay()
                      ), //IconButton

                      IconButton(
                        icon: Icon(Icons.add_box),
                        tooltip: 'Next',
                        onPressed: () =>  _NextDay(),
                      ), //IconButton
                    ]
                  )
              ]

            ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today_outlined),
              tooltip: 'Date',
              onPressed: () => _selectDate(context),
            ), //IconButton

            IconButton(
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () => _saveChanges(),
            ), //IconButton

            IconButton(
             icon: Icon(Icons.delete),
             tooltip: 'Delete',
            onPressed: () => -DeleteFiles(),
            ), //IconButton
          ], //<Widget>[]
          backgroundColor: Colors.greenAccent[400],
          elevation: 50.0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Menu Icon',
            onPressed: () {},
          ), //IconButton
          brightness: Brightness.dark,
        ), //AppBar
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
             controller: _scrollController,
            child: Row(
              children: List.generate(
                BEs.length,
                    (col) =>
                    Column(
                      children: List.generate(timeRows * 4,
                              (row) {
                                if (col == 0) {

                                  return ProduceTimeCell(row);
                                }

                                else if (row == 0)
                                   return produceUnitColumn(row,col);
                                else {

                                  return   ProduceCell( inputMode, row, col, buForToday, BEs,_toggleInput,context,adminMode);;
                                }

                              //  }
                          }
                      ),
                    ),
              ),
            ),
          ),
        )
    );

    return scaffold;
  }
//when the build is finished scroll to the nearest hour
 void  onAfterBuild(){
 // _scrollController.animateTo((hour-2) * _ItemHeight, duration: new Duration(seconds: 2), curve: Curves.ease);
}


  AddNewBUs(){
    var sevenDaysFromNow = DateTime.now().add(new Duration(days: 7));
    BU bu =  Globals.lastCreatedBU.copy();
    bu.ids = new List<String>();
    Globals.lastCreatedBU.ids.forEach((element) {bu.ids.add(element);});
    bu.bookingStart = sevenDaysFromNow.millisecondsSinceEpoch;
    setState(() {

       allbookings.add(bu);

    });

   // fileservice.saveBUs(jsonEncode(allbookings));
  }
  DeleteFiles() async
  {
 //   await fileservice.deleteFiles();
    BU selectedBU = buForToday.singleWhere((item) => item.selected == true );
    selectedBU.selected = false;
    setState(() {
      buForToday.remove(selectedBU);
      allbookings.remove(selectedBU);
    });
  }
  _NextDay(){
    String test = selectedDate.toLocal().toString();
    DateTime picked = selectedDate.add(Duration(days : 1));
    ToSelectedDate(picked);
 //   DateTime today =  DateTime.parse(selectedDate)
  }
  _PrevDay(){

    DateTime picked = selectedDate.add(Duration(days : -1));
    ToSelectedDate(picked);
    //   DateTime today =  DateTime.parse(selectedDate)
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
        ToSelectedDate(picked);
    }
  }
  ToSelectedDate( DateTime picked) async {
     selectedDate = picked;
     buForToday = allbookings.where((element) =>
     DateTime
         .fromMillisecondsSinceEpoch(element.bookingStart)
         .day == selectedDate.day).toList();
   //  String json2 = await fileservice.readRepeatingBUs();


     setState(() {
   //    if (json2.startsWith('[')) {
  //       repeatingBUs = (json.decode(json2) as List).map((i) =>
   //          BU.fromJson(i)).toList();
         buForToday.addAll(repeatingBUs);
    //   }
    //   else
     //    buForToday.add(BU.fromJson(json.decode(json2)));
     });
   }
   void  _saveChanges  () async {
     BU bu;
     try{
       bu =  buForToday.singleWhere((item) => item.type == TypeBooking.editing);
     }
     catch (e) {
       _showDialog("can only be one object in editting mode ");
     }

     bu.type = TypeBooking.Booked;
     Globals.editingstate = false;
     Globals.lastCreatedBU = Globals.UnderConstructionBU;
     Globals.UnderConstructionBU = null;
     bu.bookingStart = selectedDate.millisecondsSinceEpoch; // Convert DateTime into timestamp so it can be stored into firebase document
     allbookings.add(bu);
     Globals.UnderConstructionBU = null;



      if (!adminMode)
        fileservice.saveBUs(jsonEncode(buForToday));
      else {
         await _showRangeDialog();
        if (_value == 1) {
          bu.bRepeatingDaily = true;
          repeatingBUs.add(bu);
          fileservice.saveAdminBUs(jsonEncode(repeatingBUs));
        }
      }

     setState(() {
     });
  }

  void _showDialog(String err) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("internal logic error"),
          content: new Text(err),
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

    _showRangeDialog() async {
     await showDialog(
         context: context,
         builder:  (_) => getRange(context)
     );

  }

   Widget getRange(     BuildContext context) {
     double timeDilation = 10;
     bool _isChecked = false;
      return Dialog(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            Text(
              'Repeat:',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            DropdownButton(
                value: _value,
                items: [
                  DropdownMenuItem(
                    child: Text("Daily"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("Weekly"),
                    value: 2,
                  ),

                ],
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                }),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context,1);
              },
              color: Color(0xFFfab82b),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),


      );
  }
  bool user1,user2,user3,user4;
  void _showTestDialog() {

    showDialog(

      context: context,
      builder: (context) {
        return StatefulBuilder( // StatefulBuilder
          builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                Container(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Student Attendence",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CheckboxListTile(
                          value: true,
                          title: Text("user1"),
                          onChanged: (value){
                            setState(() {
                              user1=value;
                            });
                          },
                        ),
                        Divider(
                          height: 10,
                        ),
                        CheckboxListTile(
                          value: true,
                          title: Text("user2"),
                          onChanged: (value){
                            setState(() {
                              user2=value;
                            });
                          },
                        ),
                        Divider(
                          height: 10,
                        ),
                        CheckboxListTile(
                          value: true,
                          title: Text("user3"),
                          onChanged: (value){
                            setState(() {
                              user3=value;
                            });
                          },
                        ),
                        Divider(
                          height: 10,
                        ),
                        CheckboxListTile(
                          value: true,
                          title: Text("user4"),
                          onChanged: (value){
                            setState(() {
                              user4=value;
                            });
                          },
                        ),
                        Divider(
                          height: 10,
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Material(
                              elevation: 5.0,
                              color: Colors.blue[900],
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(
                                    10.0, 5.0, 10.0, 5.0),
                                onPressed: () {},
                                child: Text("Save",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    )),
                              ),
                            ),
                            Material(
                              elevation: 5.0,
                              color: Colors.blue[900],
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(
                                    10.0, 5.0, 10.0, 5.0),
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text("Cancel",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    )),
                              ),
                            ),
                            Material(
                              elevation: 5.0,
                              color: Colors.blue[900],
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(
                                    10.0, 5.0, 10.0, 5.0),
                                onPressed: () {},
                                child: Text("Select All",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            );
          },
        );
      },
    );
  }
}


