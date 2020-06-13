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
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text('Memo Memo', style: TextStyle(fontSize: 36,
                color: Colors.deepOrange)),
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
        tooltip: 'Tab if you want to add new note',
        label: Text('Add New Note'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Memo>>loadMemo() async{
    DBHelper helper = DBHelper();
    return await helper.memos();
  }

  Widget memoBuilder() {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Container(child: Text('Try writing a new memo!'),);
        }
        return ListView.builder(
          itemCount: snap.data.length,
          itemBuilder: (context, index) {
            Memo memo = snap.data[index];
            return Column(
              children: <Widget>[
                Text(memo.title),
                Text(memo.editedAt),
                Text(memo.text),
              ],
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}