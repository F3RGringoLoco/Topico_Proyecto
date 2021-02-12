import 'package:flutter/material.dart';
import 'package:servtecnico/controllers/databasehelpers.dart';

class ListTechs extends StatefulWidget {
  @override
  _ListTechsState createState() => _ListTechsState();
}

class _ListTechsState extends State<ListTechs> {
  DataBaseHelper databaseHelper = new DataBaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Lista de Tecnicos"),
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
                pageBuilder: (a, b, c) => ListTechs(),
                transitionDuration: Duration(seconds: 0),
              ));
          return Future.value(false);
        },
        child: FutureBuilder<List>(
          future: databaseHelper.getTechsWithImage(),
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
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            /*onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DetailWork(
                        list: list,
                        index: i,
                      )),
            ),*/
            child:
                /*new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  children: <Widget>[
                    Image(
                        image: NetworkImage(list[i]['cover_image'].toString())),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          list[i]['name'].toString(),
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                        subtitle: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                  'Telefono: ${list[i]['number'].toString()}',
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal)),
                              new Text(
                                  'Ubicación: ${list[i]['location'].toString()}',
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal)),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              //margin: EdgeInsets.all(1),
              /*child: new ListTile(
                //dense: true,
                leading: Image.network(
                  list[i]['cover_image'].toString(),
                  height: 250,
                  fit: BoxFit.fitHeight,
                ),
                title: Text(
                  list[i]['name'].toString(),
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                ),
                subtitle: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text('Telefono: ${list[i]['number'].toString()}',
                          style: new TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)),
                      new Text('Ubicación: ${list[i]['location'].toString()}',
                          style: new TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal)),
                    ]),
              ),*/
            ),*/
                new Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.check),
                    title: Text(list[i]['name'].toString(),
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    /*subtitle: Text(
                      'Secondary Text',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),*/
                  ),
                  Image(image: NetworkImage(list[i]['cover_image'].toString())),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new ListTile(
                      subtitle: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                                'Telefono: ${list[i]['number'].toString()}',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal)),
                            new Text(
                                'Ubicación: ${list[i]['location'].toString()}',
                                style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal)),
                          ]),
                    ),

                    /*Text(
                      'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),*/
                  ),
                  /*ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      FlatButton(
                        textColor: const Color(0xFF6200EE),
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('ACTION 1'),
                      ),
                      FlatButton(
                        textColor: const Color(0xFF6200EE),
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('ACTION 2'),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
