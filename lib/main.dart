import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'screen.dart';

void main() {
  // 方向
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // 状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  if (Platform.isIOS) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Money',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '订餐费用结算'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  double _box = 0;
  double _delivery = 0;
  double _discount = 0;
  var _string = '';
  var _totalPrices = new Map();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _reduceCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        _totalPrices.remove(_counter);
      }
    });
  }

  void _calculate() {
    print(_totalPrices);

    var moneys = new Map();

    // 配送费加餐盒费用
    var addition = (_box + _delivery) / _counter;

    // 计算每人的费用
    var total = 0.0;
    _totalPrices.forEach((k, v) {
        double money = double.parse(v);
        double count = (money + addition) - _discount / 2;
        total = total + count;
        moneys[(k+1).toString() + '号订单人'] = count;
      });

    setState(() {
      _string = '总额：' + total.toString() + '\n明细：' + moneys.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 分辨率
    MCScreen.instance = MCScreen(width: 414, height: 736)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body(),
      persistentFooterButtons: <Widget>[
        FloatingActionButton(
          onPressed: _incrementCounter,
          child: Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: _reduceCounter,
          child: Icon(Icons.remove),
        ),
      ],
    );
  }


  Widget body() {
    return ListView.builder(
        itemCount: _counter + 1,
        itemBuilder: (BuildContext context, int index) {
        return (index == _counter) ? count() : item(index);
    });
  }

  Widget item(int index) {
    var title = (index+1).toString() + '号订餐人';
    return Card(
      child: Container(
          padding: EdgeInsets.only(top: MCScreen().setHeight(20), bottom: MCScreen().setHeight(20),
              left: MCScreen().setHeight(10), right: MCScreen().setHeight(10)),
          child:  Wrap(
              direction: Axis.vertical,
              children: <Widget>[
                Text(title),
                money(index),
              ]
          )
      ),
    );
  }

  Widget money(int index) {
    return Container(
      width: MCScreen.screenWidth,
      height: MCScreen().setHeight(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('总价'),
          Container(
            color: Colors.lightBlue,
            width: MCScreen().setHeight(200), height: MCScreen().setHeight(30),
            child: CupertinoTextField(
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                if (value.isEmpty) {
                 _totalPrices.remove(index);
                } else {
                  _totalPrices[index] = value;
                }
                print(_totalPrices);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget count() {
    return Container(
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[

          Container(
            padding: EdgeInsets.all(MCScreen().setHeight(10)),
            width: MCScreen.screenWidth,
            height: MCScreen().setHeight(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('餐盒'),
                Container(
                  color: Colors.lightBlue,
                  width: MCScreen().setWidth(200), height: MCScreen().setHeight(30),
                  child: CupertinoTextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      value = (value.isEmpty) ? "0" : value;
                      _box = double.parse(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(MCScreen().setHeight(10)),
            width: MCScreen.screenWidth,
            height: MCScreen().setHeight(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('配送费'),
                Container(
                  color: Colors.lightBlue,
                  width: MCScreen().setWidth(200), height: MCScreen().setHeight(30),
                  child: CupertinoTextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      value = (value.isEmpty) ? "0" : value;
                      _delivery = double.parse(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(MCScreen().setHeight(10)),
            width: MCScreen.screenWidth,
            height: MCScreen().setHeight(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('优惠'),
                Container(
                  color: Colors.lightBlue,
                  width: MCScreen().setWidth(200), height: MCScreen().setHeight(30),
                  child: CupertinoTextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      value = (value.isEmpty) ? "0" : value;
                      _discount = double.parse(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(MCScreen().setHeight(50)),
            width: MCScreen.screenWidth,
            height: MCScreen().setHeight(50),
            child: Center(child: Text(_string, style: TextStyle(color: Colors.red))),
          ),

          Container(
            padding: EdgeInsets.all(MCScreen().setHeight(50)),
            width: MCScreen.screenWidth,
            child: Center(
              child: FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: _calculate,
                  child: Text('结算')
              ),
            ),
          ),

        ],
      ),
    );
  }

}
