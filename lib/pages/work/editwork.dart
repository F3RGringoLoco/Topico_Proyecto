import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/pages/work/listwork.dart';

class EditWork extends StatefulWidget {
  final List list;
  final int index;

  EditWork({this.list, this.index});

  @override
  _EditWorkState createState() => _EditWorkState();
}

class _EditWorkState extends State<EditWork> {
  DataBaseHelper dataBaseHelper = new DataBaseHelper();

  TextEditingController controllerId;
  TextEditingController controllerCaption;
  TextEditingController controllerDescription;
  TextEditingController controllerClientsLocation;
  TextEditingController controllerClientsName;
  TextEditingController controllerClientsNumber;
  TextEditingController controllerWorkersId;
  TextEditingController controllerWorkersName;
  TextEditingController controllerAmount;
  TextEditingController controllerConfirmed;

  @override
  void initState() {
    controllerId = new TextEditingController(
        text: widget.list[widget.index]['id'].toString());
    controllerCaption = new TextEditingController(
        text: widget.list[widget.index]['caption'].toString());
    controllerDescription = new TextEditingController(
        text: widget.list[widget.index]['description'].toString());
    controllerClientsLocation = new TextEditingController(
        text: widget.list[widget.index]['clients_location'].toString());
    controllerClientsName = new TextEditingController(
        text: widget.list[widget.index]['clients_name'].toString());
    controllerClientsNumber = new TextEditingController(
        text: widget.list[widget.index]['clients_number'].toString());
    controllerWorkersId = new TextEditingController(
        text: widget.list[widget.index]['workers_id'].toString());
    controllerWorkersName = new TextEditingController(
        text: widget.list[widget.index]['workers_name'].toString());
    controllerAmount = new TextEditingController(
        text: widget.list[widget.index]['amount'].toString());
    controllerConfirmed = new TextEditingController(
        text: widget.list[widget.index]['confirmed'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Editar"),
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
                new ListTile(
                  leading: const Icon(Icons.subject, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerCaption,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa un asunto";
                    },
                    decoration: new InputDecoration(
                      hintText: "Asunto",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                //
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.description, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerDescription,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa una descripción";
                    },
                    decoration: new InputDecoration(
                      hintText: "Descripcion",
                      //labelText: "Descripcion",
                    ),
                  ),
                ),
                //
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.location_pin, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerClientsLocation,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa ubicación del cliente";
                    },
                    decoration: new InputDecoration(
                      hintText: "Ubicación del cliente",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                //
                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerClientsName,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa nombre del cliente";
                    },
                    decoration: new InputDecoration(
                      hintText: "Nombre del cliente",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                //
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.phone, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerClientsNumber,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa telefono del cliente";
                    },
                    decoration: new InputDecoration(
                      hintText: "Telefono del cliente",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                //
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.perm_identity, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerWorkersId,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa el ID del Técnico";
                    },
                    decoration: new InputDecoration(
                      hintText: "ID del técnico",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                //
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.perm_identity, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerWorkersName,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa el nombre del Técnico";
                    },
                    decoration: new InputDecoration(
                      hintText: "Nombre del Técnico",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                //
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerAmount,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa el Monto";
                    },
                    decoration: new InputDecoration(
                      hintText: "Monto",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                new ListTile(
                  leading: const Icon(Icons.check, color: Colors.black),
                  title: new TextFormField(
                    controller: controllerConfirmed,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa el Estado";
                    },
                    decoration: new InputDecoration(
                      hintText: "Estado del trabajo (Finalizado : Incompleto)",
                      //labelText: "Asunto",
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                new RaisedButton(
                  child: new Text("Editar"),
                  color: Colors.blueAccent,
                  onPressed: () {
                    dataBaseHelper.editData(
                        controllerId.text.trim(),
                        controllerCaption.text.trim(),
                        controllerDescription.text.trim(),
                        controllerClientsLocation.text.trim(),
                        controllerClientsName.text.trim(),
                        controllerClientsNumber.text.trim(),
                        controllerWorkersId.text.trim(),
                        controllerWorkersName.text.trim(),
                        controllerAmount.text.trim(),
                        controllerConfirmed.text.trim());
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new ListWork(),
                    ));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
