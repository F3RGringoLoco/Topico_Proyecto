import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:servtecnico/controllers/databasehelpers.dart';
//import 'package:servtecnico/main.dart';
import 'package:servtecnico/pages/account/editaccount.dart';
import 'package:servtecnico/pages/login.dart';
import 'package:servtecnico/pages/technicians/listtechnician.dart';
import 'package:servtecnico/pages/work/detailwork.dart';
//import 'package:servtecnico/pages/work/editwork.dart';
//import 'package:servtecnico/pages/work/addwork.dart';
import 'package:servtecnico/pages/work/listwork.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DataBaseHelper databaseHelper = new DataBaseHelper();
  SharedPreferences sharedPreferences;
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    this.checkLoginStatus();
    this.getJsonData();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<String> getJsonData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    //String myUrl = "http://servtecnico.000webhostapp.com/api/getauthuser";
    String myUrl = "http://192.168.0.20:8000/api/getauthuser";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    //print(response.body);
    data = json.decode(response.body)['user'];
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              //databaseHelper.logout(sharedPreferences.getString("token"));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Cerrar Sesion", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      //body: Center(child: Text('Pagina principal')),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => MainPage(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: FutureBuilder<List>(
          future: databaseHelper.getData(), //getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new ItemList(
                    list: snapshot.data,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          },
        ),
      ),
      //
      drawer: Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: FutureBuilder<String>(
                  future: getJsonData(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? new Text("Bienvenido " + data["name"].toString())
                        : new Center(
                            child: new LinearProgressIndicator(),
                          );
                  }),
              accountEmail: FutureBuilder<String>(
                  future: getJsonData(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? new Text(data["email"].toString())
                        : new Center(
                            child: new LinearProgressIndicator(),
                          );
                  }),
              currentAccountPicture: FlutterLogo(),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black, Colors.purple]),
              ),
            ),
            //
            new ListTile(
              title: new Text("Listar todos los Trabajos"),
              trailing: new Icon(Icons.list),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => ListWork(),
              )),
            ),
            //
            new ListTile(
              title: new Text("Listar los Tecnicos"),
              trailing: new Icon(Icons.view_list),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => ListTechs(),
              )),
            ),
            //
            new ListTile(
              title: new Text("Cuenta"),
              trailing: new Icon(Icons.account_circle),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => EditAccount(),
              )),
            ),
            /*new ListTile(
              title: new Text("Añadir Trabajos"),
              trailing: new Icon(Icons.add),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => AddDataWork(),
              )),
            ),*/
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailWork(
                        list: list,
                        index: i,
                      )),
            ),
            child: new Card(
              child: new ListTile(
                title: Text(
                  list[i]['caption'].toString(),
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                subtitle: Text(list[i]['description'].toString(),
                    style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                leading: Icon(
                  Icons.work,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
