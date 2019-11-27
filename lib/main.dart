import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const uri = "https://api.hgbrasil.com/finance?key=47d4e69a";

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
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _changeValueReal(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _changeValueDolar(String text) {
    double _dolar = double.parse(text);
    realController.text = (_dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (_dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _changeValueEuro(String text) {
    double _euro = double.parse(text);
    realController.text = (_euro * this.euro).toStringAsFixed(2);
    dolarController.text = (_euro * this.euro / dolar).toStringAsFixed(2);
  }

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
                var children2 = <Widget>[
                  Icon(
                    Icons.monetization_on,
                    size: 150,
                    color: Colors.amber,
                  ),
                  buildTextField(
                      "Reais", "RS\$", realController, _changeValueReal),
                  Divider(),
                  buildTextField(
                      "Dolar", "US\$", dolarController, _changeValueDolar),
                  Divider(),
                  buildTextField(
                      "Euros", "€", euroController, _changeValueEuro),
                ];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children2,
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
  print(response.statusCode);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falhou ao carregar os dados');
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController control, Function change) {
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25,
    ),
    keyboardType: TextInputType.number,
    onChanged: change,
  );
}
