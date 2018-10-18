import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Währungsrechner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

  class CurrencyInputFormatter extends TextInputFormatter {
    @override
     TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue
  ) 
  {
    var value = num.parse(newValue.text);
    return new TextEditingValue(
      text: value.toStringAsFixed(2),
      selection: TextSelection.collapsed(offset: newValue.selection.end),);
  }
}

class _MyHomePageState extends State<MyHomePage> {

  num input = 0;
  num output = 0;
  num rate = 1.0;

  TextStyle currencyStyle = TextStyle(fontSize: 24.0, color: Colors.black);
  TextStyle currencyValueStyle = TextStyle(fontSize: 40.0, color: Colors.black);

  @override
  void initState() {
    http.get("https://api.exchangeratesapi.io/latest").then((response)  {
      setState(()  {
        var body = response.body;
        var rates = json.decode(body)["rates"];
        rate = rates["USD"];
      });
    });

  }
  


  Widget createCurrencyInputWidget(num value) {
    return 
       new Padding(
         padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
       child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              children: <Widget>[
            new Flexible(
              child: new TextFormField(
                textAlign: TextAlign.right,
                style: currencyValueStyle,
              keyboardType: TextInputType.number,
              initialValue: toCurrencyString(value),
              inputFormatters: [CurrencyInputFormatter()],
              onFieldSubmitted: (v) => setState(() { 
                              input = num.parse(v); 
                              output = rate * input;
                            }),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: new Text(
                'EUR',
                style: currencyStyle,
              ),
            ),
          ],
        )]
        ));
  }

  String toCurrencyString(num value) {
    return value.toStringAsFixed(2);
  }

  Widget createCurrencyOutputWidget(num value) {
    return 
       new Padding(
         padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
       child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                  child: new Text( toCurrencyString(value),
                  style: currencyValueStyle,
                  textAlign: TextAlign.right,
            ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: new Text(
                'USD',
                style: currencyStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        )]
        ));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            Expanded(child: createCurrencyInputWidget(input)),
            Expanded(child: createCurrencyOutputWidget(output)),
          ],
        ),
      ),
    );
  }
}
