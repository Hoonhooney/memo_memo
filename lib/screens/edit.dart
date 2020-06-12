import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';

class EditPage extends StatelessWidget {
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
                labelText: "Title",
              ),
            ),
            TextField(
              onChanged: (String text){this.text = text;},
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Text",
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
      id: 3,
      title: this.title,
      text: this.text,
      createdAt: DateTime.now().toString(),
      editedAt: DateTime.now().toString()
    );

    await helper.insertMemo(fido);

    print(await helper.memos());
  }
}
