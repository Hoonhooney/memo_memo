import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.id}) : super(key : key);
  final String id;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  BuildContext _context;

  String title = '';
  String text = '';
  String createdAt = '';

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: updateDB,
            )
          ],
        ),
        body: loadBuilder()
    );
  }

  Future<List<Memo>>loadMemo(String id) async{
    DBHelper helper = DBHelper();
    return await helper.findMemo(id);
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

          var tecTitle = TextEditingController();
          title = memo.title;
          tecTitle.text = title;

          var tecText = TextEditingController();
          text = memo.text;
          tecText.text = text;

          createdAt = memo.createdAt;

          return Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tecTitle,
                  onChanged: (String title){this.title = title;},
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Title",
                  ),
                ),
                TextField(
                  controller: tecText,
                  onChanged: (String text){this.text = text;},
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "Text",
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void updateDB() async{
    DBHelper helper = DBHelper();

    var fido = Memo(
        id: widget.id,
        title: this.title,
        text: this.text,
        createdAt: this.createdAt,
        editedAt: DateTime.now().toString().split('.')[0]
    );

    await helper.updateMemo(fido);

    Navigator.pop(_context);
  }
}
