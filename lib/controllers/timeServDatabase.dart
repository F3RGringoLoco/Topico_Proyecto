import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SaveTimeServDatabaseHelper {
  String serverUrl = "http://192.168.0.18:8000/api";
  //String serverUrl = "http://servtecnico.000webhostapp.com/api";
  var status;
  var token;

  void saveTimeServ(String id, String days, String init, String end) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/savetimeservices";
    http.post(myUrl, headers: {
      'Accept': 'aplication/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "id": "$id",
      "days": "$days",
      "init": "$init",
      "end": "$end"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  saveTimeServ1(String id, String days, String init, String end) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'id': id, 'days': days, 'inicio': init, 'fin': end};
    var jsonResponse = null;

    var response = await http.post("$serverUrl/saveServ", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        sharedPreferences.setString("token", jsonResponse['token']);
      }
    } else {
      print(response.body);
    }
  }

  Future<Map<String, dynamic>> hasSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/hasschedule";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  //Delete Schedules of Service
  void deleteSchedules(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/deleteschedules";
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
}
