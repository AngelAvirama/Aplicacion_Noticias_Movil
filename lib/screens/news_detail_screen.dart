import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news.dart';
import '../providers/news_provider.dart';
import 'news_form_screen.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;
  NewsDetailScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(news.title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news.category, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(news.body),
            Spacer(),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Editar'),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsFormScreen(news: news),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Eliminar'),
                  onPressed: () {
                    provider.deleteNews(news.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
