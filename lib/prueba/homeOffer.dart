import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:servtecnico/prueba/loginPage.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';

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
    //this.getJsonData();
    this.getUserInfo();
  }

  /*checkInfoStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Page()),
          (Route<dynamic> route) => false);
    }
  }*/

  getUserInfo() async {
    data = await databaseHelper.getJsonData();
  }

  clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.indigo, Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              clearSharedPref();
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
            new Container(
              child: FutureBuilder<Map<String, dynamic>>(
                future: databaseHelper.getJsonData(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? new UserAccountsDrawerHeader(
                          accountName:
                              new Text("Bienvenido " + data["name"].toString()),
                          accountEmail: new Text(data["email"].toString()),
                          currentAccountPicture: CircleAvatar(
                            radius: 15.0,
                            backgroundImage:
                                NetworkImage(data["cover_image"].toString()),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.indigo, Colors.purple],
                            ),
                          ),
                        )
                      : new Center(
                          child: new LinearProgressIndicator(),
                        );
                },
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
          padding: const EdgeInsets.all(1.0),
          child: new GestureDetector(
            /*onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailWork(
                        list: list,
                        index: i,
                      )),
            ),*/
            child: new Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image:
                              NetworkImage(list[i]['cover_image'].toString()),
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(list[i]['name'].toString(),
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
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

            /*new Card(
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
            ),*/
          ),
        );
      },
    );
  }
}
