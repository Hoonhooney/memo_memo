class Memo{
  final int id;
  final String title;
  final String text;
  final String createdAt;
  final String editedAt;

  Memo({this.id, this.title, this.text, this.createdAt, this.editedAt});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'text' : text,
      'createdAt' : createdAt,
      'editedAt' : editedAt,
    };
  }

  @override
  String toString(){
    return 'Memo{id: $id, title: $title, text: $text, createTime: $createdAt, editTime: $editedAt}';
  }
}