import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../screens/news_detail_screen.dart';
import '../screens/news_form_screen.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).loadNews();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<NewsProvider>(context, listen: false).loadNews();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Noticias')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(labelText: 'Buscar...'),
              onChanged: provider.searchNews,
            ),
          ),
          Expanded(
            child: provider.isLoading && provider.newsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.newsList.length + (provider.isLoading ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == provider.newsList.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final news = provider.newsList[index];
                      return ListTile(
                        title: Text(news.title),
                        subtitle: Text(news.category),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(news: news),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsFormScreen()),
        ),
      ),
    );
  }
}