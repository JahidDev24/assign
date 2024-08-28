// Represents a post item
class Post {
  final int id;
  final String by;
  final int time;
  final String text;
  final String title;
  final String type;
  final List<int> kids;
  final int score;
  final String url;

  Post({
    required this.id,
    required this.by,
    required this.time,
    required this.text,
    required this.title,
    required this.type,
    required this.kids,
    required this.score,
    required this.url,
  });

  // Factory method to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      by: json['by'],
      time: json['time'],
      text: json['text'] ?? '',
      title: json['title'] ?? '',
      type: json['type'],
      kids: List<int>.from(json['kids'] ?? []),
      score: json['score'] ?? 0,
      url: json['url'] ?? "",
    );
  }
}
