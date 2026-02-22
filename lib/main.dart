import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wikipedia_reader/summary.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ArticleViewModel(ArticleModel());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Wikipedia Flutter")),
        body: Center(child: Text('Loading...')),
      ),
    );
  }
}

// The ViewModel in MVVM
class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model) {
    getRandomArticleSummary();
  }

  Future<void> getRandomArticleSummary() async {
    loading = true;
    notifyListeners();
    try {
      summary = await model.getRandomArticleSummary();
      print('Article loaded: ${summary!.titles.normalized}'); // Temporary
      errorMessage = null;
    } on HttpException catch (error) {
      print('Error loading article: ${error.message}'); // Temporary
      errorMessage = error.message;
      summary = null;
    }
    loading = false;
    notifyListeners();
  }
}

// The Model in MVVM
class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    // https://en.wikipedia.org/api/rest_v1/page/random/summary
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw HttpException('Failed to update resources');
    }

    return Summary.fromJson(json.decode(response.body));
  }
}
