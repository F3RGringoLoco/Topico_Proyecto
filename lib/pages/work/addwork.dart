import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/pages/start.dart';

class AddDataWork extends StatefulWidget {
  AddDataWork({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddDataWorkState createState() => _AddDataWorkState();
}

class _AddDataWorkState extends State<AddDataWork> {
  DataBaseHelper databaseHelper = new DataBaseHelper();

  final TextEditingController _captionController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _clientslocationController =
      new TextEditingController();
  final TextEditingController _clientsnameController =
      new TextEditingController();
  final TextEditingController _clientsnumberController =
      new TextEditingController();
  final TextEditingController _workersidController =
      new TextEditingController();
  final TextEditingController _workersnameController =
      new TextEditingController();
  final TextEditingController _amountController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Añadir Trabajos'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.only(
              top: 62, left: 12.0, right: 12.0, bottom: 12.0),
          children: <Widget>[
            Container(
              height: 50,
              child: new TextField(
                controller: _captionController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //labelText: 'Asunto del Trabajo',
                  hintText: 'Asunto del Trabajo',
                  icon: new Icon(Icons.subject),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  //labelText: 'Descripcion',
                  hintText: 'Descripcion del Trabajo',
                  icon: new Icon(Icons.description),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _clientslocationController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  //labelText: 'Ubicacion',
                  hintText: 'Ubicacion del Cliente',
                  icon: new Icon(Icons.my_location),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _clientsnameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  //labelText: 'Nombre',
                  hintText: 'Nombre del Cliente',
                  icon: new Icon(Icons.person_pin),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _clientsnumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  //labelText: 'Telefono',
                  hintText: 'Telefono del Cliente',
                  icon: new Icon(Icons.phone),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _workersidController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  //labelText: 'ID',
                  hintText: 'ID del Tecnico',
                  icon: new Icon(Icons.perm_identity),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _workersnameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  //labelText: 'Nombre',
                  hintText: 'Nombre del Tecnico',
                  icon: new Icon(Icons.perm_identity_outlined),
                ),
              ),
            ),
            //
            SizedBox(height: 5.0),
            Container(
              height: 50,
              child: new TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  //labelText: 'Monto',
                  hintText: 'Monto total del Trabajo',
                  icon: new Icon(Icons.attach_money),
                ),
              ),
            ),

            new Padding(
              padding: new EdgeInsets.only(top: 44.0),
            ),
            Container(
              height: 50,
              child: new RaisedButton(
                onPressed: () {
                  databaseHelper.addDataWork(
                      _captionController.text.trim(),
                      _descriptionController.text.trim(),
                      _clientslocationController.text.trim(),
                      _clientsnameController.text.trim(),
                      _clientsnumberController.text.trim(),
                      _workersidController.text.trim(),
                      _workersnameController.text.trim(),
                      _amountController.text.trim());
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new StartPage(),
                  ));
                },
                color: Colors.blue,
                child: new Text(
                  'Añadir',
                  style: new TextStyle(
                      color: Colors.white, backgroundColor: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
