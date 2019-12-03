import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance?format=jsonkey=b5a87e5f";

void main() async{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
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

  final realcontroller = TextEditingController();
  final dolarcontroller = TextEditingController();
  final eurocontroller = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
      double real = double.parse(text);
      dolarcontroller.text = (real/dolar).toStringAsFixed(2);
      eurocontroller.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realcontroller.text = (dolar*this.dolar).toStringAsFixed(2);
    eurocontroller.text = (dolar*this.dolar/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = (double.parse(text));
    realcontroller.text = (euro*this.euro).toStringAsFixed(2);
    dolarcontroller.text = (euro*this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados..." ,
              style: TextStyle(color: Colors.amber,
              fontSize: 25.0),
              textAlign: TextAlign.center,));
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar dados" ,
                  style: TextStyle(color: Colors.amber,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,));
              }else{
                dolar=snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro=snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,),

                      buildTextField("Reais", "R\$",realcontroller,_realChanged),
                      Divider(),
                      buildTextField("Dólares", "US\$",dolarcontroller,_dolarChanged),
                      Divider(),
                      buildTextField("euros", "EUR\$",eurocontroller,_euroChanged),

                    ],
                  ),
                );
              }
          }

        }
      ),
    );
  }
}


Widget buildTextField(String label, String prefix,TextEditingController control, Function funcao){
  return TextField(

      controller: control ,
      decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
  border: OutlineInputBorder(),
  prefixText: prefix
  ),
  style: TextStyle(
  color: Colors.amber, fontSize: 25.0
  ),
    onChanged: funcao,
    keyboardType: TextInputType.number,
  );
}