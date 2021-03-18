import 'dart:async';
import 'package:servtecnico/prueba/homeView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/controllers/requestsDatabase.dart';

import 'package:servtecnico/prueba/loginPage.dart';
import 'package:servtecnico/prueba/homeOffer.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  RequestsDatabaseHelper requestDB = new RequestsDatabaseHelper();
  DataBaseHelper databaseHelper = new DataBaseHelper();
  SharedPreferences sharedPreferences;
  Map<String, dynamic> data;

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Ofertas"),
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
                pageBuilder: (a, b, c) => RequestPage(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: FutureBuilder<List>(
          future: requestDB.getRequets(),
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
                builder: (BuildContext context) => HomeViewPage(),
              )),
            ),
            Divider(
              height: 3,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              title: new Text("Solicitudes"),
              trailing: new Icon(Icons.request_page),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => RequestPage(),
              )),
            ),
            Divider(
              height: 3,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              title: new Text("Buscar Servicios"),
              trailing: new Icon(Icons.local_offer),
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
          ],
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  RequestsDatabaseHelper requestDB = new RequestsDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return new Container(
            padding: const EdgeInsets.all(1.0),
            child: new GestureDetector(
              onTap: () => {
                showDialog<void>(
                    context: context,
                    //barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        title: list[index]['status_finish'] == 1
                            ? list[index]['status_confirme'] == 0
                                ? Text(
                                    'Oferta Rechazado',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  )
                                : Text(
                                    'Trabajo Finalizado',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                            : Text(
                                'Oferta Pendiente',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow),
                              ),
                        content: SingleChildScrollView(
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      list[index]['service_name'].toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.monetization_on,
                                          size: 15,
                                        ),
                                        new Text(
                                            'Oferta de : ${list[index]['amount'].toString()} ',
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.normal)),
                                        new Text(' Bs.',
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          RichText(
                                            //textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: 'Cliente : ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: list[index]['name']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            //textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: 'Ubicación : ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: list[index]
                                                            ['location']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            //textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: 'Publicada : ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: list[index]
                                                            ['created_at']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            //textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: 'Finalizada : ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: list[index]
                                                            ['updated_at']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            //textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text: 'Descripción : ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: list[index]
                                                            ['description']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                          list[index]['status_finish'] == 0
                              ? list[index]['status_confirme'] == 0
                                  ? new Row(
                                      children: <Widget>[
                                        new RaisedButton(
                                          child: new Text(
                                            "Rechazar",
                                            style: new TextStyle(
                                                color: Colors.black),
                                          ),
                                          color: Colors.red,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          onPressed: () {
                                            requestDB.changeRequestStatus(
                                                list[index]['id'].toString(),
                                                0);
                                            Navigator.of(context)
                                                .push(new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RequestPage(),
                                            ));
                                          },
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        new RaisedButton(
                                          child: new Text(
                                            "Aceptar",
                                            style: new TextStyle(
                                                color: Colors.black),
                                          ),
                                          color: Colors.green,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          onPressed: () {
                                            requestDB.changeRequestStatus(
                                                list[index]['id'].toString(),
                                                1);
                                            Navigator.of(context)
                                                .push(new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RequestPage(),
                                            ));
                                          },
                                        ),
                                      ],
                                    )
                                  : new RaisedButton(
                                      child: new Text(
                                        "Finalizar Trabajo",
                                        style:
                                            new TextStyle(color: Colors.black),
                                      ),
                                      color: Colors.greenAccent,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () {
                                        requestDB.endRequest(
                                            list[index]['id'].toString());
                                        Navigator.of(context)
                                            .push(new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new RequestPage(),
                                        ));
                                      },
                                    )
                              : Text('')
                        ],
                      );
                    }),
              },
              child: new Card(
                margin: EdgeInsets.all(5.0),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            //textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Para el Servicio de : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        list[index]['service_name'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                            //textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Monto de oferta : ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${list[index]['amount'].toString()} Bs.',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                          ),
                          RichText(
                            //textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Descripción : ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: list[index]['description'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.work_rounded,
                        color: list[index]['status_finish'] == 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      /*leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(list[index]['cover_image'].toString()),
                      ),*/
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
