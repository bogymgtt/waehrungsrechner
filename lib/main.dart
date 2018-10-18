import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Currency',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Currency'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  num inputEU = 0;
  num outputUSD = 0;
  num rate = 1.153;
  String inputCurrency = 'EUR';
  String outputCurrency = 'USD';

  @override
  void initState() {
    http.get("https://api.exchangeratesapi.io/latest").then((response) {
      setState(() {
        var body = response.body;
        var rates = json.decode(body)["rates"];
        rate = rates["USD"];
      });
    });
  }

  Widget createCurrencyWidget() {
    return Container(
      decoration: new BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue[200], Colors.grey],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter)),
      child: new Padding(
          padding: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Flexible(
                        child: new TextField(
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 30.0,
                                color: Colors.black),
                            onSubmitted: (t) => setState(() {
                                  inputEU = num.parse(t);
                            outputUSD = inputCurrency == 'EUR'
                                ? inputEU * rate
                                : inputEU / rate;
                                }),
                            keyboardType: TextInputType.number)),
                    new DropdownButton<String>(
                        value: inputCurrency,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                        ),
                        items: <String>["EUR", "USD"].map((String value) {
                          return new DropdownMenuItem<String>(
                              value: value, child: new Text(value));
                        }).toList(),
                        onChanged: (text) {
                          setState(() {
                            inputCurrency = text;
                            outputCurrency =
                                inputCurrency == 'EUR' ? 'USD' : 'EUR';
                            outputUSD = inputCurrency == 'EUR'
                                ? inputEU * rate
                                : inputEU / rate;
                          });
                        }),
                  ],
                ),
              ])),
    );
  }

  Widget createCurrencyWidget2() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.grey,
      ),
      child: Container(
        decoration: new BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Colors.grey,
              Colors.red[300]
            ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter)),
        child: new Padding(
            padding: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Flexible(
                            fit: FlexFit.tight,
                            child: new Text(
                              outputUSD.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 30.0,
                              ),
                            )),
                        new Text(outputCurrency,
                        style: new TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 30.0
                         ))

                       
                      ],
                    )
                  ]),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: new Center(
              child: createCurrencyWidget(),
            ),
          ),
          Flexible(
            child: new Center(
              child: createCurrencyWidget2(),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
