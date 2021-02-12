import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:servtecnico/prueba/loginPage.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';

/*class ServPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeOfferPage(),
    );
  }
}*/

class HomeOfferPage extends StatefulWidget {
  @override
  _HomeOfferPageState createState() => _HomeOfferPageState();
}

class _HomeOfferPageState extends State<HomeOfferPage> {
  DataBaseHelper databaseHelper = new DataBaseHelper();
  SharedPreferences sharedPreferences;
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    //this.checkInfoStatus();
    this.getJsonData();
  }

  /*checkInfoStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Page()),
          (Route<dynamic> route) => false);
    }
  }*/

  Future<String> getJsonData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://192.168.0.20:8000/api/getauthuser";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Cerrar Sesion", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => HomeOfferPage(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: FutureBuilder<List>(
          future: databaseHelper.getTechsWithImage(),
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
            /*new ListTile(
              title: new Text("Listar los Tecnicos"),
              trailing: new Icon(Icons.view_list),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => ListTechs(),
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
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            /*onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailWork(
                        list: list,
                        index: i,
                      )),
            ),*/
            child: new Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.check),
                    title: Text(list[i]['name'].toString(),
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  Image(
                    image: NetworkImage(list[i]['cover_image'].toString()),
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new ListTile(
                      subtitle: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                                'Telefono: ${list[i]['number'].toString()}',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal)),
                            new Text(
                                'Ubicación: ${list[i]['location'].toString()}',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
