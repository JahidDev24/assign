import 'package:dio/dio.dart';
import 'package:siyatech_assig_app/Model/Comment.dart';
import 'package:siyatech_assig_app/repositories/NetworkConfig.dart';
import 'package:siyatech_assig_app/repositories/endpints.dart';
import '../Model/post.dart';

class HackerNewsRepository {
  static final HackerNewsRepository _hackerNewsRepository =
      HackerNewsRepository._internal();

  late Dio _dio;

  factory HackerNewsRepository() {
    return _hackerNewsRepository;
  }

  HackerNewsRepository._internal() {
    initializeDio();
  }

  Future<void> initializeDio() async {
    _dio = await DioFactory().getDio();
  }

  Future<List<int>> fetchTopStoryIds() async {
    final response = await _dio.get(Endpoint.GET_IDS);
    if (response.statusCode != 200) {
      throw Exception('Failed to load top story IDs');
    }
    return List<int>.from(response.data);
  }

  Future<Post> fetchPost(int id) async {
    final response =
        await _dio.get('${Endpoint.GET_ITEMS}/$id.json?print=pretty');
    if (response.statusCode != 200) throw Exception('Failed to load post');
    return Post.fromJson(response.data);
  }

  Future<CommentTile> fetchComment(int id) async {
    final response =
        await _dio.get('${Endpoint.GET_ITEMS}/$id.json?print=pretty');
    if (response.statusCode != 200) throw Exception('Failed to load post');
    return CommentTile.fromJson(response.data);
  }
}
