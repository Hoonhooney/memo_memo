import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Text('Memo Memo', style: TextStyle(fontSize: 36,
                    color: Colors.blue)),
              )
            ],
          ),
          ...loadMemos()
        ] ,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context,
            CupertinoPageRoute(builder: (context) => EditPage())
          );
        },
        tooltip: 'Tab if you want to add new note',
        label: Text('Add New Note'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> loadMemos() {
    List<Widget> memoList = [];
    memoList.add(Container(color: Colors.red, height: 100,));
    return memoList;
  }
}