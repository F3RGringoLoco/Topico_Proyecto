import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {
  String serverUrl = "http://192.168.0.20:8000/api";
  String serverUrlWork = "http://192.168.0.20:8000/api/work";
  var status;

  var token;

  //create function for login
  loginData(String email, String password) async {
    String myUrl = "$serverUrl/login";
    final response = await http.post(
      myUrl,
      headers: {'Accept': 'aplication/json'},
      body: {"email": "$email", "password": "$password"},
    );

    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
    }
  }

  //Logout
  logout(String actualtoken) async {
    String myUrl = "$serverUrl/logout";
    http.post(
      myUrl,
      headers: {'Accept': 'aplication/json'},
      body: {"token": "$actualtoken"},
    ).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //create function for register Users
  registerUserData(String name, String email, String password) async {
    String myUrl = "$serverUrl/register";
    final response = await http.post(
      myUrl,
      headers: {'Accept': 'aplication/json'},
      body: {"name": "$name", "email": "$email", "password": "$password"},
    );

    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //Edit Account
  void editAccount(
    String id,
    String name,
    String email,
    String number,
    String location,
    //String status,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/editAccount";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
      "name": "$name",
      "email": "$email",
      "location": "$location",
      "number": "$number",
      //"status": "$status",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //Change Account Status
  void changeStatus(String id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/changestatus";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
      "status": "$status"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //Delete account
  removeAccount(id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/deleteAccount";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //Function for register work
  void addDataWork(
      String _captionController,
      String _descriptionController,
      String _clientslocationController,
      String _clientsnameController,
      String _clientsnumberController,
      String _workersidController,
      String _workersnameController,
      String _amountController) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrlWork";
    final response = await http.post(myUrl, headers: {
      'Accept': 'aplication/json'
    }, body: {
      "caption": "$_captionController",
      "description": "$_descriptionController",
      "clients_location": "$_clientslocationController",
      "clients_name": "$_clientsnameController",
      "clients_number": "$_clientsnumberController",
      "workers_id": "$_workersidController",
      "workers_name": "$_workersnameController",
      "amount": "$_amountController",
    });

    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for update or put
  void editData(
      String id,
      String caption,
      String description,
      String clientsLocation,
      String clientsName,
      String clientsNumber,
      String workersId,
      String workersName,
      String amount,
      String confirmed) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrlWork/$id";
    http.put(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "caption": "$caption",
      "description": "$description",
      "clients_location": "$clientsLocation",
      "clients_name": "$clientsName",
      "clients_number": "$clientsNumber",
      "workers_id": "$workersId",
      "workers_name": "$workersName",
      "amount": "$amount",
      "confirmed": "$confirmed",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //function to delete
  removeRegister(id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/deletework";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //function getData
  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrlWork";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  Future<List> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/allwork";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  //function save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  //function read
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read: $value');
  }

  //function to get user info
  Future<List> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/getauthuser";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    print(response.body);
    return json.decode(response.body)['user'];
  }

  //Get List of techs with images
  Future<List> getTechsWithImage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/techs";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });

    return json.decode(response.body);
  }
}
