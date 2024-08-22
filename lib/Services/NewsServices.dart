import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = 'bca61748c4794e2298ff5781fb6ce137';
  final String baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<dynamic>> fetchNews(String category) async {
    final url = category.isEmpty
        ? '$baseUrl?q=general&apiKey=$apiKey'
        : '$baseUrl?q=$category&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}