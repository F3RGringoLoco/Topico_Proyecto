import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:servtecnico/controllers/servSelected.dart';
import 'package:servtecnico/controllers/timeServDatabase.dart';
import 'package:servtecnico/prueba/homeView.dart';

String daysValue;
TimeOfDay inicio = TimeOfDay(hour: 7, minute: 15);
TimeOfDay fin = TimeOfDay(hour: 7, minute: 15);

class TimeServPage extends StatefulWidget {
  @override
  _TimeServPageState createState() => _TimeServPageState();
}

class _TimeServPageState extends State<TimeServPage> {
  SaveServDatabaseHelper serv = new SaveServDatabaseHelper();
  SaveTimeServDatabaseHelper servTime = new SaveTimeServDatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Mis Servicios"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.indigo, Colors.purple],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => TimeServPage(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: FutureBuilder<List>(
          future: serv.getUserServ(),
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
      bottomNavigationBar: Container(
        height: 40.0,
        margin: EdgeInsets.all(10),
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HViewPage()));
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
                "Finalizar",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  SaveTimeServDatabaseHelper servTime = new SaveTimeServDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return new Container(
          child: new GestureDetector(
            /*onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailWork(
                        list: list,
                        index: i,
                      )),
            ),*/
            child: new Card(
              color: Colors.white70,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              //clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  new ListTile(
                    contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                    title: Text(
                      list[index]['service_name'].toString(),
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    //trailing: Icon(Icons.more_vert),
                    subtitle: new Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          list[index]['schedules'].length > 0
                              ? Table(
                                  border: TableBorder.all(
                                    color: Colors.black,
                                    width: 0.4,
                                  ),
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                        child: Center(
                                          child: Text('Dia(s)',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('Hora Inicio',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text('Hora Fin',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                    ])
                                  ],
                                )
                              : new Text('No tienes ningun Horario'),
                          for (var i = 0;
                              i < list[index]['schedules'].length;
                              i++)
                            new Table(
                              border: TableBorder.all(
                                  color: Colors.black, width: 0.2),
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                          list[index]['schedules'][i]['day']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                          list[index]['schedules'][i]
                                                  ['morning_time']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Center(
                                      child: Text(
                                          list[index]['schedules'][i]
                                                  ['afternoon_time']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          //new Text(
                          //list[index]['schedules'][i]['id'].toString()),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          servTime
                              .deleteSchedules(list[index]['id'].toString());
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (a, b, c) => TimeServPage(),
                                transitionDuration: Duration(seconds: 0),
                              ));
                          return Future.value(false);
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                child: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 17.5,
                            )),
                            TextSpan(
                                text: 'Eliminar Horarios',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15)),
                          ]),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              //barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Horario de :' +
                                      " " +
                                      list[index]['service_name']),
                                  content: SingleChildScrollView(
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          SelectedDaysUpdateExample(),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyHomePage(),
                                              new Flexible(
                                                  child: MyHomePage1()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        child: Text('Guardar Horario'),
                                        onPressed: () {
                                          //print(daysValue.toString());
                                          //print(inicio.toString());
                                          //print(fin.toString());
                                          servTime.saveTimeServ(
                                              list[index]['id'].toString(),
                                              daysValue.toString(),
                                              inicio.format(context).toString(),
                                              fin.format(context).toString());
                                          daysValue = '';
                                          inicio =
                                              TimeOfDay(hour: 7, minute: 15);
                                          fin = TimeOfDay(hour: 7, minute: 15);
                                          Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (a, b, c) =>
                                                    TimeServPage(),
                                                transitionDuration:
                                                    Duration(seconds: 0),
                                              ));
                                          return Future.value(false);
                                        })
                                  ],
                                );
                              });
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                child: Icon(
                              Icons.add,
                              color: Color(0xFF0D47A1),
                              size: 17.5,
                            )),
                            TextSpan(
                                text: 'Añadir Horario',
                                style: TextStyle(
                                    color: Color(0xFF0D47A1), fontSize: 15)),
                          ]),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

printIntAsDay(int day) {
  print('Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
}

String intDayToEnglish(int day) {
  if (day % 7 == DateTime.monday % 7) return 'Lunes';
  if (day % 7 == DateTime.tuesday % 7) return 'Martes';
  if (day % 7 == DateTime.wednesday % 7) return 'Miercoles';
  if (day % 7 == DateTime.thursday % 7) return 'Jueves';
  if (day % 7 == DateTime.friday % 7) return 'Viernes';
  if (day % 7 == DateTime.saturday % 7) return 'Sabado';
  if (day % 7 == DateTime.sunday % 7) return 'Domingo';
  throw '🐞 This should never have happened: $day';
}

class ExampleTitle extends StatelessWidget {
  final String title;

  const ExampleTitle(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: Theme.of(context).textTheme.title),
    );
  }
}

String valuesToEnglishDays(List<bool> values, bool searchedValue) {
  final days = <String>[];
  for (int i = 0; i < values.length; i++) {
    final v = values[i];
    // Use v == true, as the value could be null, as well (disabled days).
    if (v == searchedValue) days.add(intDayToEnglish(i));
  }
  if (days.isEmpty) return 'NINGUNO';
  daysValue = days.toString();
  return days.join(', ');
}

class SelectedDaysUpdateExample extends StatefulWidget {
  @override
  _SelectedDaysUpdateExampleState createState() =>
      _SelectedDaysUpdateExampleState();
}

class _SelectedDaysUpdateExampleState extends State<SelectedDaysUpdateExample> {
  final values = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    final DateSymbols mx = dateTimeSymbolMap()['es_MX'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
            'Los dias seleccionados son: ${valuesToEnglishDays(values, true)}.'),
        WeekdaySelector(
          weekdays: mx.STANDALONEWEEKDAYS,
          shortWeekdays: mx.STANDALONENARROWWEEKDAYS,
          firstDayOfWeek: mx.FIRSTDAYOFWEEK + 1,
          selectedFillColor: Colors.deepPurple,
          onChanged: (v) {
            printIntAsDay(v);
            setState(() {
              values[v % 7] = !values[v % 7];
            });
          },
          values: values,
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        //inicio = newTime;
      });
    }
    inicio = _time;
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          onPressed: _selectTime,
          child: Text('Hora Inicio'),
        ),
        SizedBox(height: 8),
        Text(
          'Inicio: ${_time.format(context)}',
        ),
      ],
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  @override
  _MyHomePage1State createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  TimeOfDay _time1 = TimeOfDay(hour: 7, minute: 15);

  void _selectTime1() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time1,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time1 = newTime;
      });
    }
    fin = _time1;
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          onPressed: _selectTime1,
          child: Text('Hora Final'),
        ),
        SizedBox(height: 8),
        Text(
          'Final: ${_time1.format(context)}',
        ),
      ],
    );
  }
}
