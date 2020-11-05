import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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
  ScrollController _scrollController ;
  double _ItemHeight = 240;
  List<Offset> bb = List<Offset>();
  int hour;
  List<BU>   myModels;



  void initState() {
    super.initState();
    _scrollController = new ScrollController();


  //  fileservice.saveBUs(jsonEncode(slots));
    fileservice.readBUs().then((String json1) {
      setState(() {
           inputMode = false;
           allbookings=(json.decode(json1) as List).map((i) =>
            BU.fromJson(i)).toList();
          buForToday = allbookings.where((element) => DateTime.fromMillisecondsSinceEpoch(element.bookingStart).day == DateTime.now().day).toList();
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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          actions: <Widget>[
            RaisedButton(
            onPressed: () => _saveChanges(), // Refer step 3
            child: Text(
              'Book',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            color: Colors.greenAccent,
          ),
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            RaisedButton(
              onPressed: () => _selectDate(context), // Refer step 3
              child: Text(
                'Select date',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),

          ],
        ),
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

                                  return   ProduceCell( inputMode, row, col, buForToday, BEs,_toggleInput,context);;
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
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        buForToday = allbookings.where((element) => DateTime.fromMillisecondsSinceEpoch(element.bookingStart).day == selectedDate.day).toList();
     
      });
  }

  void _saveChanges() {
    setState(() {
      BU bu;
      try{
        bu =  buForToday.singleWhere((item) => item.type == TypeBooking.editing);
      }
      catch (e) {
        _showDialog();
      }

      bu.type = TypeBooking.Booked;
      Globals.editingstate = false;
      Globals.selectedBU = null;
      bu.bookingStart = DateTime.now().millisecondsSinceEpoch; // Convert DateTime into timestamp so it can be stored into firebase document
      Globals.selectedBU = null;

      fileservice.saveBUs(jsonEncode(buForToday));

    });
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("internal logic error"),
          content: new Text("can only be one object in editting mode "),
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



}

