import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';

import 'edit.dart'; // for the utf8.encode method

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage>{
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){
                showAlertDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: (){
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => EditPage(id: widget.id)
                )).then((value) {
                  setState(() {});
                });
              },
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: loadBuilder()
        )
    );
  }

  Future<List<Memo>>loadMemo(String id) async{
    DBHelper helper = DBHelper();
    return await helper.findMemo(id);
  }

  Future<void>deleteMemo(String id) async{
    DBHelper helper = DBHelper();
    await helper.deleteMemo(id);
    Navigator.pop(context);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot){
        if (snapshot.data.isEmpty || snapshot.data == null) {
          return Container(
            alignment: Alignment.center,
            child: Text('error : cannot open this memo!',
                style: TextStyle(fontSize: 20, color: Colors.grey)),);
        } else {
          Memo memo = snapshot.data[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Text(memo.title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                  )
              ),
              Text('created at : ${memo.createdAt}', style: TextStyle(fontSize: 10, color: Colors.grey),),
              Text('last edited at : ${memo.editedAt}', style: TextStyle(fontSize: 10, color: Colors.grey),),
              Padding(padding: EdgeInsets.only(top:20),),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(memo.text, style: TextStyle(fontSize: 20),),
                ),
              )
            ],
          );
        }
      },
    );
  }

  //  alert dialog for deleting memo
  void showAlertDialog(BuildContext context) async {
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
                  deleteMemo(widget.id);
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
