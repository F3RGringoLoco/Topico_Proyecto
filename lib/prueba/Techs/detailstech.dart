import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/techsinfo.dart';
import 'package:servtecnico/prueba/homeOffer.dart';

final _formKey = GlobalKey<FormState>();
final TextEditingController serviceController = new TextEditingController();
final TextEditingController amountController = new TextEditingController();
final TextEditingController descriptionController = TextEditingController();
List<String> data;
String id;

class DetailTech extends StatefulWidget {
  List list;
  int index;
  DetailTech({this.index, this.list});

  @override
  _DetailTechState createState() => _DetailTechState();
}

class _DetailTechState extends State<DetailTech> {
  TechsDatabaseHelper techDB = new TechsDatabaseHelper();

  @override
  void initState() {
    super.initState();
    //this.getUserInfo();
  }

  getUserInfo() async {
    id = widget.list[widget.index]['id'].toString();
    data = await techDB.getTechInfo2(id);
  }

  clearInputs() {
    serviceController.clear();
    amountController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Información del Trabajador"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.indigo, Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => DetailTech(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: new Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 50),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.list[widget.index]['name'].toString(),
                    style: TextStyle(
                        fontSize: 25,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.star_rate,
                        size: 15,
                      ),
                      new Text(
                          '${widget.list[widget.index]['rate'].toString()} ',
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal)),
                      new Text(
                          '- (${widget.list[widget.index]['cant_rated'].toString()})',
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
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
                                  text: widget.list[widget.index]['location']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          //textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Telefono : ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.list[widget.index]['number']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          //textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Fecha Nacimiento : ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.list[widget.index]['date']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          height: 8,
                          thickness: 3,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Text(
                          'Servicios : ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: FutureBuilder<List>(
                            future: techDB.getTechInfo2(
                                widget.list[widget.index]['id'].toString()),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cerrar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              //barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  title: Text('Solicitud a :' +
                                      " " +
                                      widget.list[widget.index]['name']),
                                  content: SingleChildScrollView(
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          FormRequest(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        child: Text('Enviar Oferta'),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (amountController.text == "" ||
                                                descriptionController.text ==
                                                    "" ||
                                                serviceController.text == "") {
                                              return null;
                                            } else {
                                              techDB.setRequest(
                                                  widget.list[widget.index]
                                                          ['id']
                                                      .toString(),
                                                  amountController.text,
                                                  descriptionController.text,
                                                  serviceController.text);
                                            }
                                          }
                                          clearInputs();
                                          /*SnackBar(
                                            content: Text(
                                                'Solicitud realizado con exito!'),
                                          );*/

                                          //Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (a, b, c) =>
                                                    HomeOfferPage(),
                                                transitionDuration:
                                                    Duration(seconds: 0),
                                              ));
                                          return Future.value(false);
                                        })
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Solicitar',
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image(
                    image: NetworkImage(
                        widget.list[widget.index]['cover_image'].toString()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return new Container(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //data.add(list[index]['service_name'].toString()),
                  Align(
                    alignment: FractionalOffset(0.22, 0.5),
                    child: Text(
                      list[index]['service_name'].toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  list[index]['schedules'].length > 0
                      ? Table(
                          defaultColumnWidth: FixedColumnWidth(
                              MediaQuery.of(context).size.width / 5),
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
                                          color: Colors.red, fontSize: 16)),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text('Hora Inicio',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16)),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text('Hora Fin',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16)),
                                ),
                              ),
                            ])
                          ],
                        )
                      : new Text('Sin horario'),
                  for (var i = 0; i < list[index]['schedules'].length; i++)
                    new Table(
                      defaultColumnWidth: FixedColumnWidth(
                          MediaQuery.of(context).size.width / 5),
                      border: TableBorder.all(color: Colors.black, width: 0.2),
                      children: [
                        TableRow(children: [
                          TableCell(
                            child: Center(
                              child: Text(
                                  list[index]['schedules'][i]['day'].toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                  list[index]['schedules'][i]['morning_time']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                  list[index]['schedules'][i]['afternoon_time']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                            ),
                          ),
                        ])
                      ],
                    ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class FormRequest extends StatefulWidget {
  @override
  _FormRequestState createState() => _FormRequestState();
}

class _FormRequestState extends State<FormRequest> {
  TechsDatabaseHelper techDB = new TechsDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.name,
                controller: serviceController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  icon: Icon(Icons.work, color: Colors.black),
                  hintText: "Servicio",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo Servicio no puede ser vacia';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amountController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on, color: Colors.black),
                  hintText: "Monto Bs.",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo Monto no puede ser vacia';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5.0),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: descriptionController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.description,
                    color: Colors.black,
                    size: 30,
                  ),
                  hintText: "Descripción",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo Descripción no puede ser vacia';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
