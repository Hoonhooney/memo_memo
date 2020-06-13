import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'edit.dart';
import 'package:memomemo/database/db.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30, bottom: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('Memo Memo', style: TextStyle(fontSize: 36,
                  color: Colors.deepOrange)),
            )
          ),
          Expanded(child: memoBuilder()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context,
            CupertinoPageRoute(builder: (context) => EditPage())
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: 'Tap if you want to add a new note',
        label: Text('Add a New Note'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Memo>>loadMemo() async{
    DBHelper helper = DBHelper();
    return await helper.memos();
  }

  Future<void>deleteMemo(String id) async{
    DBHelper helper = DBHelper();
    await helper.deleteMemo(id);
  }

//  memo list view builder
  Widget memoBuilder() {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.data.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: Text('write a new memo!\n\n\n\n\n\n',
              style: TextStyle(fontSize: 20, color: Colors.grey)),);
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snap.data.length,
          itemBuilder: (context, index) {
            Memo memo = snap.data[index];
            return InkWell(
              onTap: (){},
              onLongPress: (){
                showAlertDialog(context, memo);
              },
              child: Container(
                  height: 80,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 1,
                    ),
                    boxShadow: [BoxShadow(color: Colors.orangeAccent, blurRadius: 3)],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(memo.title,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                          Text(memo.text,
                              style: TextStyle(fontSize: 15, color: Colors.black54)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('last edited : ${memo.editedAt}',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                            textAlign: TextAlign.end,),
                        ],
                      )
                    ],
                  )
              ),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }

//  alert dialog for deleting memo
  void showAlertDialog(BuildContext context, Memo memo) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text("Are you sure you want to delete this memo?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context, 'delete');
                setState(() {
                  deleteMemo(memo.id);
                });
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, 'cancel');
              },
            ),
          ],
        );
      },
    );
  }
}