import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _service = NewsService();
  List<News> _newsList = [];
  List<News> get newsList => _filteredNews;
  List<News> _filteredNews = [];
  bool isLoading = false;
  int _currentPage = 1;
  bool hasMorePages = true;

  Future<void> loadNews({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _newsList = [];
      _filteredNews = [];
      hasMorePages = true;
    }

    if (!hasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final newNews = await _service.fetchNews(page: _currentPage);
      if (newNews.isEmpty) {
        hasMorePages = false;
      } else {
        _newsList.addAll(newNews);
        _filteredNews = _newsList;
        _currentPage++;
      }
    } catch (e) {
      print('Error: $e');
    }
    
    isLoading = false;
    notifyListeners();
  }

  void searchNews(String query) {
    _filteredNews = _newsList
        .where((news) =>
            news.title.toLowerCase().contains(query.toLowerCase()) ||
            news.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void deleteNews(int id) {
    _newsList.removeWhere((news) => news.id == id);
    _filteredNews.removeWhere((news) => news.id == id);
    _service.deleteNews(id);
    notifyListeners();
  }

  void addNews(News news) {
    _newsList.insert(0, news);
    //_filteredNews.insert(0, news);
    notifyListeners();
  }

  void editNews(News updatedNews) {
    final index = _newsList.indexWhere((n) => n.id == updatedNews.id);
    if (index != -1) {
      _newsList[index] = updatedNews;
      _filteredNews[index] = updatedNews;
      notifyListeners();
    }
  }
}
