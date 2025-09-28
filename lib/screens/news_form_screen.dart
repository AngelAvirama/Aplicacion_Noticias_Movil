import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news.dart';
import '../providers/news_provider.dart';

class NewsFormScreen extends StatefulWidget {
  final News? news;
  NewsFormScreen({this.news});

  @override
  _NewsFormScreenState createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String body;
  late String category;

  @override
  void initState() {
    super.initState();
    title = widget.news?.title ?? '';
    body = widget.news?.body ?? '';
    category = widget.news?.category ?? 'General';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text(widget.news == null ? 'Nueva Noticia' : 'Editar Noticia')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              initialValue: title,
              decoration: InputDecoration(labelText: 'Título'),
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              onSaved: (value) => title = value!,
            ),
            TextFormField(
              initialValue: body,
              decoration: InputDecoration(labelText: 'Contenido'),
              maxLines: 4,
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              onSaved: (value) => body = value!,
            ),
            TextFormField(
              initialValue: category,
              decoration: InputDecoration(labelText: 'Categoría'),
              onSaved: (value) => category = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newNews = News(
                    id: widget.news?.id ?? DateTime.now().millisecondsSinceEpoch,
                    title: title,
                    body: body,
                    category: category
                  );
                  widget.news == null
                      ? provider.addNews(newNews)
                      : provider.editNews(newNews);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Noticia guardada exitosamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
