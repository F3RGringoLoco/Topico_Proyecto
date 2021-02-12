import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:servtecnico/prueba/inputChips.dart';
import 'package:servtecnico/prueba/servform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/prueba/loginPage.dart';
import 'package:servtecnico/prueba/homeView.dart';
import 'package:servtecnico/prueba/homeOffer.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  DataBaseHelper databaseHelper = new DataBaseHelper();
  SharedPreferences sharedPreferences;
  String name;

  @override
  void initState() {
    super.initState();
    this.checkLoginStatus();
    this.getName();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://192.168.0.20:8000/api/nameUser";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    name = json.decode(response.body)['name'];
    return "Success";
  }

  Widget _label() {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          'Bienvenido!!!',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        SizedBox(
          height: 1,
        ),
        FutureBuilder<String>(
            future: getName(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? new Text(name.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 30))
                  : new Center(
                      child: new LinearProgressIndicator(),
                    );
            }),
      ],
    ));
  }

  Widget _serviceButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InputChipPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffffffff).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Ofrecer Servicios',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeViewPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0x00000000).withAlpha(100),
                offset: Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
        ),
        child: Text(
          'Ver Servicios',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Serv',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 60,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'Téc',
              style: TextStyle(color: Colors.black, fontSize: 60),
            ),
            /*TextSpan(
              text: 'Técnico',
              style: TextStyle(color: Colors.white, fontSize: 60),
            ),*/
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.all(Radius.circular(5)),
              /*boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],*/
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.purple])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              SizedBox(
                height: 150,
              ),
              _label(),
              SizedBox(
                height: 90,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text('Que vas a hacer hoy ?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              _serviceButton(),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),
              SizedBox(
                height: 20,
              ),
              //_label()
            ],
          ),
        ),
      ),
    );
  }
}
