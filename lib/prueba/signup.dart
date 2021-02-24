import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:servtecnico/prueba/Widget/bezierContainer.dart';
import 'package:servtecnico/prueba/loginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File _image;
  final picker = ImagePicker();
  var myFormat = DateFormat('d-MM-yyyy');
  var formattedDate;

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500.0,
        maxWidth: 500.0);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500.0,
        maxWidth: 500.0);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  signIn(String name, String date, number, String location, String email, pass,
      String image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'date': date,
      'number': number,
      'location': location,
      'email': email,
      'password': pass,
      'image': image,
    };
    var jsonResponse = null;

    var response =
        await http.post("http://192.168.0.20:8000/api/register", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        //sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Widget _imageButtons() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue],
                  begin: FractionalOffset.centerLeft,
                  end: FractionalOffset.centerRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton.icon(
                onPressed: () {
                  getCamera();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.camera),
                label: Text(
                  'Cámara',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            new Flexible(
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FlatButton.icon(
                  onPressed: () {
                    getImage();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.folder_open),
                  label: Text('Galería'),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController numberController = new TextEditingController();
  final TextEditingController locationController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPasswordController =
      new TextEditingController();

  Container _registerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Center(
                child: _image == null
                    ? GestureDetector(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              //barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Elija una opción'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _imageButtons(),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blueGrey,
                          child: ClipRRect(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              //barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Elija una opción'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _imageButtons(),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blueGrey,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              _image,
                              width: 100,
                            ),
                          ),
                        ),
                      )),
            SizedBox(height: 5.0),
            TextFormField(
              controller: nameController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.black),
                hintText: "Nombre Completo",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo Nombre no puede ser vacia';
                }
                return null;
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              controller: dateController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                icon: Icon(Icons.date_range, color: Colors.black),
                hintText: "Fecha de nacimiento",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                DateTime date = DateTime(1900);
                FocusScope.of(context).requestFocus(new FocusNode());

                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2002),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2003));

                //dateCtl.text = date.toString();
                formattedDate = "${date.day} / ${date.month} / ${date.year}";
                dateController.text = formattedDate.toString();
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo Fecha de Nacimiento no puede ser vacia';
                }
                return null;
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: numberController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.phone, color: Colors.black),
                hintText: "Teléfono Movil",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo Telefono no puede ser vacia';
                } else {
                  String p = r'(^(?:[+0]9)?[0-9]{8,11}$)';
                  RegExp regExp = new RegExp(p);
                  if (!regExp.hasMatch(value)) {
                    return 'Telefono invalido';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: locationController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.pin_drop, color: Colors.black),
                hintText: "Dirección",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo Dirección no puede ser vacia';
                }
                return null;
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.email, color: Colors.black),
                hintText: "Correo Electrónico",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Campo Correo Electrónico no puede ser vacia';
                } else {
                  /*bool isValidEmail() {
                    return RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value);
                  */
                  String p = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
                  RegExp regExp = new RegExp(p);
                  if (!regExp.hasMatch(value)) {
                    return 'Correo Electrónico incorrecto';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              cursorColor: Colors.black,
              obscureText: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.black),
                hintText: "Contraseña",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Contrasena vacia';
                } else {
                  if (value.length < 8) {
                    return 'Contraseña invalida, debe ser por lo menos de 8 caracteres';
                  }
                }
                return null;
              },
            ),
            SizedBox(height: 5.0),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: confirmPasswordController,
              cursorColor: Colors.black,
              obscureText: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.black),
                hintText: "Confirmar Contraseña",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'confirmación de contrasena vacia';
                }
                if (value != passwordController.text) {
                  return 'La contraseña no coincide';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (nameController.text == "" ||
                dateController.text == "" ||
                numberController.text == "" ||
                locationController.text == "" ||
                emailController.text == "" ||
                passwordController.text == "" ||
                _image == null) {
              return null;
            } else {
              setState(() {
                _isLoading = true;
              });
              //List<int> imageBytes = _image.readAsBytesSync();
              String base64Image = base64Encode(_image.readAsBytesSync());
              signIn(
                  nameController.text,
                  dateController.text,
                  numberController.text,
                  locationController.text,
                  emailController.text,
                  passwordController.text,
                  base64Image);
            }
          }
        },
        /*nameController.text == "" ||
                numberController.text == "" ||
                locationController.text == "" ||
                emailController.text == "" ||
                passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                signIn(
                    nameController.text,
                    numberController.text,
                    locationController.text,
                    emailController.text,
                    passwordController.text);
              },*/
        elevation: 30.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Registrar",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(3),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ya tienes una cuenta ?',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Registro  ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 35,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'ServTéc',
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .2),
                          _title(),
                          SizedBox(
                            height: 10,
                          ),
                          _registerSection(),
                          SizedBox(
                            height: 10,
                          ),
                          _submitButton(),
                          _loginAccountLabel(),
                        ],
                      ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
