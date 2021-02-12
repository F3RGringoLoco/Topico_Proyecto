import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  DataBaseHelper dataBaseHelper = new DataBaseHelper();
  SharedPreferences sharedPreferences;
  Map<String, dynamic> userdata;
  Map<String, dynamic> techdata;
  //bool _checked;

  TextEditingController controllerID;
  TextEditingController controllerName;
  TextEditingController controllerEmail;
  TextEditingController controllerNumber;
  TextEditingController controllerLocation;
  TextEditingController controllerStatus;

  Future<String> getUserJsonData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    //String myUrl = "http://servtecnico.000webhostapp.com/api/getauthuser";
    String myUrl = "http://192.168.0.20:8000/api/getauthuser";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    userdata = json.decode(response.body)['user'];
    //print(userdata);
    return "Success";
  }

  Future<String> getTechJsonData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    //String myUrl = "http://servtecnico.000webhostapp.com/api/gettech";
    String myUrl = "http://192.168.0.20:8000/api/gettech";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    techdata = json.decode(response.body)['tech'];
    //print(techdata);
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.getUserJsonData();
    this.getTechJsonData();
  }

  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Esta seguro de guardar cambios?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: <Widget>[
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
            dataBaseHelper.editAccount(
                controllerID.text.trim(),
                controllerName.text.trim(),
                controllerEmail.text.trim(),
                controllerNumber.text.trim(),
                controllerLocation.text.trim());
            //controllerStatus.text.trim());
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new EditAccount(),
            ));
          },
        ),
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
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Cuenta"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            new Column(
              children: <Widget>[
                Visibility(
                  child: new ListTile(
                    title: FutureBuilder(
                        future: getUserJsonData(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? TextFormField(
                                  enabled: false,
                                  controller: controllerID =
                                      new TextEditingController(
                                          text: userdata["id"].toString()),
                                )
                              : new Center(
                                  child: new LinearProgressIndicator(),
                                );
                        }),
                  ),
                  maintainState: true,
                  visible: false,
                ),
                //
                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: FutureBuilder(
                      future: getUserJsonData(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? TextFormField(
                                controller: controllerName =
                                    new TextEditingController(
                                        text: userdata["name"].toString()),
                                validator: (value) {
                                  if (value.isEmpty) return "Nombre";
                                },
                                decoration: new InputDecoration(
                                  hintText: "Nombre",
                                ),
                              )
                            : new Center(
                                child: new LinearProgressIndicator(),
                              );
                      }),
                ),
                //
                new ListTile(
                  leading: const Icon(Icons.email, color: Colors.black),
                  title: FutureBuilder(
                      future: getUserJsonData(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? TextFormField(
                                controller: controllerEmail =
                                    new TextEditingController(
                                        text: userdata["email"].toString()),
                                validator: (value) {
                                  if (value.isEmpty) return "Email";
                                },
                                decoration: new InputDecoration(
                                  hintText: "@Email",
                                ),
                              )
                            : new Center(
                                child: new LinearProgressIndicator(),
                              );
                      }),
                ),
                //
                new ListTile(
                  leading: const Icon(Icons.phone, color: Colors.black),
                  title: FutureBuilder(
                      future: getTechJsonData(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? TextFormField(
                                controller: controllerNumber =
                                    new TextEditingController(
                                        text: techdata["number"].toString()),
                                validator: (value) {
                                  if (value.isEmpty) return "Telefono Movil";
                                },
                                decoration: new InputDecoration(
                                  hintText: "Telefono",
                                ),
                                keyboardType: TextInputType.number,
                              )
                            : new Center(
                                child: new LinearProgressIndicator(),
                              );
                      }),
                ),
                //
                new ListTile(
                  leading: const Icon(Icons.location_pin, color: Colors.black),
                  title: FutureBuilder(
                      future: getTechJsonData(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? TextFormField(
                                controller: controllerLocation =
                                    new TextEditingController(
                                        text: techdata["location"].toString()),
                                validator: (value) {
                                  if (value.isEmpty) return "Ubicacion";
                                },
                                decoration: new InputDecoration(
                                  hintText: "Direccion",
                                ),
                              )
                            : new Center(
                                child: new LinearProgressIndicator(),
                              );
                      }),
                ),
                //
                Visibility(
                  child: new ListTile(
                    leading: const Icon(Icons.online_prediction,
                        color: Colors.black),
                    title: FutureBuilder(
                        future: getTechJsonData(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? TextFormField(
                                  controller: controllerStatus =
                                      new TextEditingController(
                                          text: techdata["status"].toString()),
                                )
                              : new Center(
                                  child: new LinearProgressIndicator(),
                                );
                        }),
                  ),
                  maintainState: true,
                  visible: false,
                ),
                //
                SizedBox(height: 5.0),

                const Divider(
                  height: 1.0,
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                new RaisedButton(
                  child: new Text("Editar"),
                  color: Colors.blueAccent,
                  onPressed: () => confirm(),
                ),
                FutureBuilder(
                  future: getTechJsonData(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? RaisedButton(
                            child: techdata['status'] == 1
                                ? Text("Cambiar a Activo")
                                : Text("Cambiar a Inactivo"),
                            color: techdata['status'] == 1
                                ? Colors.green
                                : Colors.redAccent,
                            onPressed: () {
                              dataBaseHelper.changeStatus(
                                  controllerID.text.trim(),
                                  controllerStatus.text.trim());
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new EditAccount(),
                              ));
                            })
                        : new Center(
                            child: new LinearProgressIndicator(),
                          );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
