//import 'dart:convert';
//import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/pages/start.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:servtecnico/pages/work/editwork.dart';
//import 'package:servtecnico/pages/work/listwork.dart';

class DetailWork extends StatefulWidget {
  List list;
  int index;
  DetailWork({this.index, this.list});

  @override
  _DetailWorkState createState() => _DetailWorkState();
}

class _DetailWorkState extends State<DetailWork> {
  DataBaseHelper dataBaseHelper = new DataBaseHelper();

  //create function delete
  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
          "Esta seguro de finalizar '${widget.list[widget.index]['caption']}'"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "Si finalizar!",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.green,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          onPressed: () {
            dataBaseHelper.removeRegister(widget.list[widget.index]['id']);
            //remove(widget.list[widget.index]['id']);
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new MainPage(),
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
        appBar: AppBar(
          title: new Text("${widget.list[widget.index]['caption']}"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.purple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
          ),
        ),
        body: new Container(
          height: 450.0,
          padding: const EdgeInsets.all(10.0),
          child: new Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                  new Text(
                    widget.list[widget.index]['caption'],
                    style: new TextStyle(fontSize: 22.0),
                  ),
                  Divider(),
                  new Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Descripcion : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        TextSpan(
                            text: '${widget.list[widget.index]['description']}',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  //
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Ubicacion : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        TextSpan(
                            text:
                                '${widget.list[widget.index]['clients_location']}',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  //
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Nombre Cliente : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        TextSpan(
                            text:
                                '${widget.list[widget.index]['clients_name']}',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  //
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Telefono Cliente : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        TextSpan(
                            text:
                                '${widget.list[widget.index]['clients_number']}',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  //
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Monto (BS.) : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0)),
                        TextSpan(
                            text: '${widget.list[widget.index]['amount']}',
                            style: TextStyle(fontSize: 18.0))
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),

                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                  //Visibility(
                  //visible: widget.list[widget.index]['confirmed'] == 0
                  //? true
                  //: false,
                  //child:
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /*new RaisedButton(
                          child: new Text("Editar"),
                          color: Colors.blueAccent,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          onPressed: () =>
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new EditWork(
                                    list: widget.list, index: widget.index),
                              ))),
                      VerticalDivider(),*/
                      widget.list[widget.index]['confirmed'] == 0
                          ? new RaisedButton(
                              child: new Text("Finalizar"),
                              color: Colors.green,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () => confirm(),
                            )
                          : new Text(
                              'Finalizado',
                              style: new TextStyle(
                                  fontSize: 22.0, color: Colors.red),
                            ),
                    ],
                  ) //)
                ],
              ),
            ),
          ),
        ));
  }
}
