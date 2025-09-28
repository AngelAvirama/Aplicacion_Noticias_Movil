import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'screens/news_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider()..loadNews(),
      child: MaterialApp(
        title: 'Noticias App',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: NewsListScreen(),
      ),
    );
  }
}
