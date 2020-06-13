import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class ViewPage extends StatelessWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;
//  findMemo(id)[0];
  String title = '';
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: (){},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: LoadBuilder()
      )
    );
  }

  Future<List<Memo>>loadMemo(String id) async{
    DBHelper helper = DBHelper();
    return await helper.findMemo(id);
  }

  LoadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(id),
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
}
