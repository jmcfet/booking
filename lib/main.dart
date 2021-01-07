import 'package:flutter/material.dart';
import 'package:flutterapp/Booking.dart';
import 'globals.dart';

void main() => runApp(MyApp());
enum FormMode { LOGIN, SIGNUP, ALL }
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      ),
      home: MyHomePage(title: 'Flutter Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  FormMode _formMode = FormMode.LOGIN;
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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final myController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
   @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    Widget showEmailInput() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),

          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                new Container(
                    width:200,
                    child:new Text(' Email:',

                        style: TextStyle(fontWeight:FontWeight.bold,
                          //   background: paint,
                        )
                    )
                ),
                new Expanded(

                    child: new TextFormField(
                      maxLines: 1,
                      initialValue: 'test',
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: new InputDecoration(
                        hintText: '012345',

                      ),
                      //         validator: (val) => validateEmail(val),
                       onSaved: (value) => Globals.member.lastName = value,

                    )
                )
              ]
          )
      );
    }
    Widget showPasswordInput() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),

          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                new Container(
                    width:200,
                    child:new Text(' Password:',

                        style: TextStyle(fontWeight:FontWeight.bold,
                          //   background: paint,
                        )
                    )
                ),
                new Expanded(

                    child: new TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: 'upper lower chars 1 cap',

                      ),
                      validator: (value) {
                        if (value.isEmpty )
                          return ' Password can\'t be empty';
                        //   if (value != user.Password)
                        //     return ' Passwords must match';
                      },
                      onSaved: (value) {

                                    Globals.member.Password = value;

                      },

                    )
                )
              ]
          )
      );
    }
    Widget _showPrimaryButton(_formMode) {

      String tt = 'Login';
      if ( _formMode == FormMode.ALL)
        tt = 'Update account';
      else if ( _formMode == FormMode.SIGNUP)
        tt = 'Create account' ;


      Text text =    new Text(tt,
          style: new TextStyle(fontSize: 20.0, color: Colors.white));

      var but = new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: text,
          onPressed: (){
            _formKey.currentState.save();   //pick up what the user entered
              Globals.adminMode = false;
              if (Globals.member.lastName == 'admin' && Globals.member.Password == '42')
                  Globals.adminMode = true;

            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Booking()));}
      );

      return new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          child: SizedBox(
              height: 40.0,
              child: but
          ));
    }

    Widget _showBody1(_formMode) {
      var items = <Widget>[];
      if (_formMode == FormMode.LOGIN) {
        items.add(showEmailInput());
        items.add(showPasswordInput());
         items.add(_showPrimaryButton(_formMode));
      }
      if (_formMode == FormMode.SIGNUP ) {
   //     items.add(showTextFieldInput('First name', user.firstName,firstNameChanged));
   //     items.add(showTextFieldInput('Last name', user.lastName,lastNameChanged));

   //     items.add(showEmailInput(user));
  //      items.add(showPasswordInput(user));
   //     items.add(showConfirmPasswordInput(user));
   //     items.add(showAgeInput(user));
   //     items.add(showPhonenumInput(user));
   //     items.add(_showPrimaryButton());
      }
      if (_formMode == FormMode.ALL) {
   //     items.add(showTextFieldInput('First name', user.firstName, firstNameChanged));
  //      items.add(showTextFieldInput('Last name', user.lastName,lastNameChanged));
  //      items.add(showEmailInput(user));
  //      items.add(showAgeInput(user));
  //      items.add(showPhonenumInput(user));
   //     items.add(showHeightInput(user,heightChanged,inchesChanged));




      }



 //     if (_formMode == FormMode.SIGNUP || _formMode == FormMode.LOGIN)
  //      items.add(_showSecondaryButton());


  //    items.add(_showErrorMessage());
      Container con = new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(key: _formKey, child: ListView(children: items)));
      return con;
    }

   // return _showBody1(FormMode.LOGIN);
    var scaf = new Scaffold(
        appBar: new AppBar(
          title: new Text('Court master'),
        ),
        body: _showBody1(FormMode.LOGIN),
    );

    return scaf;
  }
}


Widget _showSecondaryButton(_formMode) {
  String tt  = 'Create an account';
  if ( _formMode == FormMode.ALL)
    tt = '';
  else if ( _formMode == FormMode.SIGNUP)
    tt = 'have an account? Sign in' ;

  return new FlatButton(
    child: new Text(tt,
        style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)
    ),

 //   onPressed: _formMode == FormMode.LOGIN
 //       ? _changeFormToSignUp
  //      : _changeFormToLogin,
  );
}


void _validateAndSubmit(context)  {
  FocusScope.of(context).requestFocus(new FocusNode());
  /* final Auth auth = new Auth();
  //  final authMock auth = new authMock();
  setState(() {
    _errorMessage = "";
    _isLoading = true;
  });
  if (!_validateAndSave()) {
    setState(() {
      _isLoading = false;
    });
    return;
  }
  //form looks good so either do a signin or register
  String userId = "";
  setState(() {
    _isLoading = false;
  });
  if (_formMode == FormMode.LOGIN) {
    UserResponse resp = await auth.signIn(user.Email, user.Password);

    if (resp.error == '200') {
      user = resp.user;
      Globals.user = user;
      widget.onSignedIn();
    } else {
      setState(() {
        _errorMessage = resp.error;
      });

    }
  } else if ( _formMode == FormMode.SIGNUP){
    UserResponse resp = await auth.signUp(user);

    if (resp.error == '200') {
      _changeFormToLogin();
    } else {
      setState(() {
        _errorMessage = resp.error;
      });
    }

  }
  else {
    UserResponse resp = await auth.Update(user);

    if (resp.error == '200') {

  */
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Booking()));
  //  } else {
  //     setState(() {
  //       _errorMessage = resp.error;
  //    });
  //   }

}











