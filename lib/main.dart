import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=87ba47de";

void main() async{
  runApp(MaterialApp(
    theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        )),
    home: Home(),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final btcController = TextEditingController();

  double dolar;
  double euro;
  double btc;

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    btcController.text = (real/btc).toStringAsFixed(7);
}

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar)/euro).toStringAsFixed(2);
    btcController.text = (dolar * this.dolar / btc).toStringAsFixed(7);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    btcController.text = (euro * this.euro / btc).toStringAsFixed(7);
  }

  void _btcChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double btc = double.parse(text);
    realController.text = (btc * this.btc).toStringAsFixed(2);
    dolarController.text = (btc * this.btc / dolar).toStringAsFixed(2);
    euroController.text = (btc * this.btc / euro).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    btcController.text = "";
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text("\$ Conversor \$", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:

            return Center(
              child: Text("Carregando Dados", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
            );

            default:
              if(snapshot.hasError){
                return Center(
                    child: Text("Erro", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                );
              }

              else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                btc = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.white),

                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólar", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro", "€", euroController, _euroChanged),
                      Divider(),
                      buildTextField("BTC", "₿", btcController, _btcChanged),

                    ],
                  ),
                );
              }

          }   //Switch
        }),
    );
  }
}


Widget buildTextField(String label, String prefix, TextEditingController moeda, Function f){

return TextField(
    controller: moeda,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixText: prefix,
        prefixStyle: TextStyle(color: Colors.white, fontSize: 25.0),
        border: OutlineInputBorder(),
    ),
    style: TextStyle(
        color: Colors.white,
        fontSize: 25.0
    ),
    onChanged: f,
  keyboardType: TextInputType.number,
);

}

