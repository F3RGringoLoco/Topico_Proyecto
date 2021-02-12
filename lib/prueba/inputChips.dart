import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

class InputChipPage extends StatefulWidget {
  InputChipPage({Key key}) : super(key: key);

  @override
  _InputChipPageState createState() => _InputChipPageState();
}

class _InputChipPageState extends State<InputChipPage> {
  final _chipKey = GlobalKey<ChipsInputState>();
  var cant = 0;
  var servicios;

  @override
  Widget build(BuildContext context) {
    const mockResults = <AppProfile>[
      AppProfile('Plomeria'),
      AppProfile('Carpinteria'),
      AppProfile('Cocinero'),
      AppProfile('Zapatero'),
      AppProfile('Pintor'),
      AppProfile('Electricista'),
      AppProfile('Mecanico'),
      AppProfile('Cosera'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ChipsInput(
                key: _chipKey,
                // autofocus: true,
                // allowChipEditing: true,
                keyboardAppearance: Brightness.dark,
                textCapitalization: TextCapitalization.words,
                enabled: true,
                //maxChips: 5,
                textStyle: const TextStyle(
                    height: 1.5, fontFamily: 'Roboto', fontSize: 16),
                decoration: const InputDecoration(
                  // prefixIcon: Icon(Icons.search),
                  // hintText: formControl.hint,
                  labelText: 'Ingrese Servicio',
                  // enabled: false,
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
                  print(data);
                  servicios = data;
                  cant = data.length;
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
                height: 20.0,
              ),
              Text('Hola'),
              /*Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: cant,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              servicios[index].name,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),*/
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
