import 'dart:convert';

class CommentTile {
  String? by;
  int? id;
  List<int>? kids;
  int? parent;
  String? text;
  int? time;
  String? type;

  CommentTile({
    this.by,
    this.id,
    this.kids,
    this.parent,
    this.text,
    this.time,
    this.type,
  });

  factory CommentTile.fromJson(Map<String, dynamic> json) => CommentTile(
        by: json["by"],
        id: json["id"],
        kids: json["kids"] == null
            ? []
            : List<int>.from(json["kids"]!.map((x) => x)),
        parent: json["parent"],
        text: json["text"],
        time: json["time"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "by": by,
        "id": id,
        "kids": kids == null ? [] : List<dynamic>.from(kids!.map((x) => x)),
        "parent": parent,
        "text": text,
        "time": time,
        "type": type,
      };
}
