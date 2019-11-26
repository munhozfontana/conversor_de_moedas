import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const uri = "https://api.hgbrasil.com/finance";

void main() async {
  http.Response response = await http.get(uri);
  print(jsonDecode(response.body)['results']['currencies']['USD']);

  runApp(
    MaterialApp(
      home: Container(),
    ),
  );
}
