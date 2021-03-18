import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TechsDatabaseHelper {
  String serverUrl = "http://192.168.0.18:8000/api";
  //String serverUrl = "http://servtecnico.000webhostapp.com/api";
  var status;
  var token;

  /*getTechsWithImage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/techs";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });

    return json.decode(response.body);
  }*/

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

  //Get filtered List
  Future<List> getTechsWithImageFilter(List services) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/techsfilter";
    http.Response response = await http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "services": "$services",
    });

    return json.decode(response.body);
  }

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

  void calif(String id, String calif) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/calif";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
      "calif": "$calif",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }
}
