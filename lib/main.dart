import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const uri = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                Center(
                  child: Text(
                    "Carregando dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                print(snapshot.data);
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "RS\$",
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dolar",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return null;
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(uri);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falhou ao carregar os dados');
  }
}
