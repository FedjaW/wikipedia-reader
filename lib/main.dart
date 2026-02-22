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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Wikipedia Flutter")),
        body: Center(child: Text('Loading...')),
      ),
    );
  }
}

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
