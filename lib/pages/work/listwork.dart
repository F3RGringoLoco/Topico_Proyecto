//import 'package:servtecnico/pages/work/detailwork.dart';
import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';
import 'package:servtecnico/pages/work/detailwork.dart';

import 'detailwork.dart';

class ListWork extends StatefulWidget {
  @override
  _ListWorksState createState() => _ListWorksState();
}

class _ListWorksState extends State<ListWork> {
  DataBaseHelper databaseHelper = new DataBaseHelper();

  /*List data;
  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://192.168.0.12:8000/api/work";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }*/

  @override
  void initState() {
    super.initState();
    //this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Lista de Trabajos"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => ListWork(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: FutureBuilder<List>(
          future: databaseHelper.getAllData(),
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
      /*body: new FutureBuilder<List>(
        future: databaseHelper.getAllData(), //getData(),
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
      ),*/
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          //padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailWork(
                        list: list,
                        index: i,
                      )),
            ),
            child: new Card(
              child: new ListTile(
                title: Text(
                  list[i]['caption'].toString(),
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                subtitle: Text(list[i]['description'].toString(),
                    style: TextStyle(fontSize: 13.0, color: Colors.grey)),
                leading: Icon(
                  Icons.work,
                  color: list[i]['confirmed'] == 0 ? Colors.green : Colors.red,
                ),
                /*title: new Text(
                  list[i]['caption'].toString(),
                  style: TextStyle(fontSize: 10.0, color: Colors.orangeAccent),
                ),*/
              ),
            ),
          ),
        );
      },
    );
  }
}
