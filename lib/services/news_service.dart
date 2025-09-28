import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  final int itemsPerPage = 10;

  Future<List<News>> fetchNews({int page = 1}) async {
    try {
      final start = (page - 1) * itemsPerPage;
      final response = await http.get(
        Uri.parse('$baseUrl?_start=$start&_limit=$itemsPerPage'),
        headers: {
          'User-Agent': 'Mozilla/5.0',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => News.fromJson({...json, 'category': 'General'})).toList();
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchNews: $e');
      throw Exception('Error al cargar noticias: $e');
    }
  }

  Future<void> deleteNews(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
