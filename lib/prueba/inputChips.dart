import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:servtecnico/controllers/servSelected.dart';
import 'package:servtecnico/prueba/setTimeServ.dart';
import 'package:servtecnico/prueba/welcomePage.dart';

class InputChipPage extends StatefulWidget {
  InputChipPage({Key key}) : super(key: key);

  @override
  _InputChipPageState createState() => _InputChipPageState();
}

class _InputChipPageState extends State<InputChipPage> {
  SaveServDatabaseHelper servSave = new SaveServDatabaseHelper();
  final _chipKey = GlobalKey<ChipsInputState>();
  List<AppProfile> servicios = [];

  @override
  Widget build(BuildContext context) {
    const mockResults = <AppProfile>[
      AppProfile('Plomeria'),
      AppProfile('Carpinteria'),
      AppProfile('Cocinero'),
      AppProfile('Zapatero'),
      AppProfile('Pintor'),
      AppProfile('Electricidad'),
      AppProfile('Mecanica'),
      AppProfile('Costurero'),
      AppProfile('Limpieza'),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => InitPage())),
        ),
        title: Text("Selección de Servicios"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.indigo, Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Text('Al parecer no tienes ningun servicio!',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          'Por favor ingrese los servicios que desea ofrecer en nuestra plataforma   ',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: 'ServTec',
                      style: GoogleFonts.portLligatSans(
                        textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                  TextSpan(
                      text: '  para asi continuar....',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ]),
              ),
              SizedBox(
                height: 30,
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
                    height: 1.5, fontFamily: 'Roboto', fontSize: 16),
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
                          .compareTo(
                              b.name.toLowerCase().indexOf(lowercaseQuery)));
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              SizedBox(
                height: 150,
              ),
              RaisedButton(
                textColor: Colors.white,
                elevation: 30,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text('Siguiente', style: TextStyle(fontSize: 20)),
                ),
                onPressed: () {
                  if (servicios.isEmpty) {
                    showDialog<void>(
                        context: context,
                        //barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Servicios Vacio!!!'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      'Seleccione por lo menos un servicio para continuar....')
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          );
                        });
                  } else {
                    String jsonProfile = jsonEncode(servicios);
                    //print(jsonProfile);
                    servSave.saveServ2(jsonProfile);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new TimeServPage()),
                        (Route<dynamic> route) => false);
                  }
                  //servicios.isNotEmpty
                  //?
                  //:
                },
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
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
