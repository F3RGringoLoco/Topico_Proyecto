import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:servtecnico/prueba/loginPage.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/controllers/techsinfo.dart';
import 'package:servtecnico/prueba/Requests/listmyrequests.dart';
import 'package:servtecnico/prueba/homeView.dart';

import 'Techs/detailstech.dart';

class HomeOfferPage extends StatefulWidget {
  @override
  _HomeOfferPageState createState() => _HomeOfferPageState();
}

class _HomeOfferPageState extends State<HomeOfferPage> {
  TechsDatabaseHelper techDB = new TechsDatabaseHelper();
  DataBaseHelper databaseHelper = new DataBaseHelper();
  //final _chipKey = GlobalKey<ChipsInputState>();
  List<AppProfile> servicios = [];
  List services = [];
  SharedPreferences sharedPreferences;
  Map<String, dynamic> data;

  /*void setListParam(param) {
    //getListParam(param);
    setState(() {
      var aux = [];
      for (var i = 0; i < services.length; i++) {
        for (var j = 0; j < services[i]['availables']; j++) {
          /*services = services
          .where((country) => country['availables']
              .whereIn(['location']).contains('Av. Banzer'))
          .toList();*/
          if (services[i]['availables'][j]['service_name'] == 'Mecanica') {
            aux.add(services[i]);
          }
        }
      }
      services = aux;
      //services = getListParam(param);
    });
  }

  getList() async {
    var response = await Dio().get("http://192.168.0.18:8000/api/techs");
    return response.data;
  }

  getListParam(param) async {
    var response = await Dio().get("http://192.168.0.18:8000/api/techs");
    return response.data;
  }*/

  @override
  void initState() {
    /*getList().then((data) {
      setState(() {
        services = data;
      });
    });*/
    super.initState();

    this.getUserInfo();
  }

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
    /*const mockResults = <AppProfile>[
      AppProfile('Plomeria'),
      AppProfile('Carpinteria'),
      AppProfile('Cocinero'),
      AppProfile('Zapatero'),
      AppProfile('Pintor'),
      AppProfile('Electricidad'),
      AppProfile('Mecanica'),
      AppProfile('Costurero'),
      AppProfile('Limpieza'),
    ];*/

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
          future: techDB.getTechsWithImage(),
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
            Divider(
              height: 3,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              title: new Text("Inicio"),
              trailing: new Icon(Icons.home),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => HomeOfferPage(),
              )),
            ),
            Divider(
              height: 3,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              title: new Text("Mis Solicitudes"),
              trailing: new Icon(Icons.view_agenda),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => MyRequestPage(),
              )),
            ),
            Divider(
              height: 3,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              title: new Text("Ofrecer Servicios"),
              trailing: new Icon(Icons.work),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => HomeViewPage(),
              )),
            ),
            Divider(
              height: 3,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Container(
        height: 40.0,
        margin: EdgeInsets.all(10),
        child: RaisedButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                //barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    content: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            new Text(
                                'Ingrese los servicios que desea filtrar...',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            new ChipsInput(
                              key: _chipKey,
                              //autofocus: true,
                              //allowChipEditing: true,
                              keyboardAppearance: Brightness.dark,
                              textCapitalization: TextCapitalization.words,
                              enabled: true,
                              //maxChips: 5,
                              textStyle: const TextStyle(
                                  height: 1.5,
                                  fontFamily: 'Roboto',
                                  fontSize: 16),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                //hintText: formControl.hint,
                                labelText: 'Ingrese Servicio',
                                //enabled: false,
                                // errorText: field.errorText,
                              ),
                              findSuggestions: (String query) {
                                if (query.isNotEmpty) {
                                  var lowercaseQuery = query.toLowerCase();
                                  return mockResults.where((profile) {
                                    return profile.name
                                        .toLowerCase()
                                        .contains(query.toLowerCase());
                                  }).toList(growable: false)
                                    ..sort((a, b) => a.name
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(b.name
                                            .toLowerCase()
                                            .indexOf(lowercaseQuery)));
                                }
                                return mockResults;
                              },
                              onChanged: (data) async {
                                if (data.isEmpty) {
                                  return;
                                }
                                //print(data);
                                //print(data.length);
                                servicios.clear();
                                for (var i = 0; i < data.length; i++) {
                                  servicios.add(data[i]);
                                }
                                //print(servicios);
                              },
                              chipBuilder: (context, state, profile) {
                                return InputChip(
                                  key: ObjectKey(profile),
                                  label: Text(profile.name),
                                  onDeleted: () => state.deleteChip(profile),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                );
                              },
                              suggestionBuilder: (context, state, profile) {
                                return ListTile(
                                  key: ObjectKey(profile),
                                  title: Text(profile.name),
                                  onTap: () => state.selectSuggestion(profile),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      new RaisedButton(
                        child: new Text(
                          "Cancelar",
                          style: new TextStyle(color: Colors.black),
                        ),
                        color: Colors.grey,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      new RaisedButton(
                          child: new Text(
                            "Guardar Cambios",
                            style: new TextStyle(color: Colors.black),
                          ),
                          color: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            //print(services);
                            setListParam(context);
                            Navigator.pop(context);
                          }),
                    ],
                  );
                });
          },
          elevation: 30.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 450.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Filtrar",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
      ),*/
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
      itemBuilder: (context, index) {
        return new Container(
            padding: const EdgeInsets.all(1.0),
            child: new GestureDetector(
              onTap: () => Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new DetailTech(
                          list: list,
                          index: index,
                        )),
              ),
              child: new Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                //clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(list[index]['name'].toString(),
                              style: new TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold)),
                          Row(
                            children: <Widget>[
                              new Icon(
                                Icons.star_rate,
                                size: 15,
                              ),
                              new Text('${list[index]['rate'].toString()} ',
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal)),
                              new Text(
                                  '- (${list[index]['cant_rated'].toString()})',
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(list[index]['cover_image'].toString()),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new ListTile(
                          subtitle: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  new Text(
                                      'Telefono: ${list[index]['number'].toString()}',
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal)),
                                  new Text(
                                      'Ubicación: ${list[index]['location'].toString()}',
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  list[index]['availables'].length > 0
                                      ? Text('Servicio(s)',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16))
                                      /*Table(
                                          border: TableBorder.all(
                                            color: Colors.grey,
                                            width: 0.4,
                                          ),
                                          children: [
                                            TableRow(children: [
                                              TableCell(
                                                child: Center(
                                                  child: Text('Servicio',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ])
                                          ],
                                        )*/
                                      : new Text('No tiene ningun Servicio'),
                                  for (var i = 0;
                                      i < list[index]['availables'].length;
                                      i++)
                                    new Text(list[index]['availables'][i]
                                            ['service_name']
                                        .toString()),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ));
      },
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class AppProfile {
  final String name;
  //final String id;

  const AppProfile(this.name); //, this.id);

  Map toJson() => {
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
