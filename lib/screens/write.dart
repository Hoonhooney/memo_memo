import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String title = '';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveDB,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String title){this.title = title;},
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Title",
                ),
              ),
              TextField(
                onChanged: (String text){this.text = text;},
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Text",
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> saveDB() async{
    DBHelper helper = DBHelper();

    var fido = Memo(
        id: strToSha512(DateTime.now().toString()),
        title: this.title,
        text: this.text,
        createdAt: DateTime.now().toString().split('.')[0],
        editedAt: DateTime.now().toString().split('.')[0]
    );

    await helper.insertMemo(fido);

    print(await helper.memos());
    Navigator.pop(context);
  }

  //hash
  String strToSha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);

    return digest.toString();
  }
}
