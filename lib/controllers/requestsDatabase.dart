import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsDatabaseHelper {
  String serverUrl = "http://192.168.0.18:8000/api";
  //String serverUrl = "http://servtecnico.000webhostapp.com/api";
  var status;
  var token;

  //Get List of user requests
  Future<List> getRequets() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/getuserrequests";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });

    return json.decode(response.body);
  }

  //Get List of active user requests
  Future<List> getActiveRequets() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/getuseractiverequests";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });

    return json.decode(response.body);
  }

  //Get specific tech information
  Future<List> getTechInfo2(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/getworkerschedules";
    final response = await http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
    });

    return json.decode(response.body);
  }

//Save request
  void setRequest(
      String id, String amount, String description, String service) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/saverequests";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
      "amount": "$amount",
      "description": "$description",
      "service": "$service"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  //Accept/Reject Request
  void changeRequestStatus(String id, status) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/changerequeststatus";
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

  //End Request
  void endRequest(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/changerequeststatus";
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

  //Get List My Requests
  Future<List> getMyRequets() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/getmyrequests";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });

    return json.decode(response.body);
  }
}
