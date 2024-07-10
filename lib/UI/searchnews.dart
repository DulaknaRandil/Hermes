import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermes/UI/featurenews.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SearchNewsTab extends StatefulWidget {
  const SearchNewsTab({Key? key}) : super(key: key);

  @override
  _SearchNewsTabState createState() => _SearchNewsTabState();
}

class _SearchNewsTabState extends State<SearchNewsTab> {
  final TextEditingController _searchController = TextEditingController();
  late List<Article> articles = [];

  void _searchArticles() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final response = await http.get(
        Uri.parse(
            'https://newsdata.io/api/1/news?apikey=pub_39701bd702c6c299b8440a77fc96ca954d83b&q=$query&language=en'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'];
        List<Article> fetchedArticles = [];
        for (var result in results) {
          final article = Article.fromJson(result);
          fetchedArticles.add(article);
        }
        setState(() {
          articles = fetchedArticles;
        });
      } else {
        throw Exception('Failed to load articles');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for news',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _searchArticles(),
            ),
          ),
          Expanded(
            child: articles.isEmpty
                ? const Center(child: Text('No articles found'))
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: InkWell(
                          onTap: () {
                            _launchURL(article.url);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (article.imageUrl != null)
                                  Image.network(article.imageUrl!),
                                const SizedBox(height: 8.0),
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Published: ${article.published}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}

class Article {
  final String id;
  final String title;
  final DateTime published;
  final String? imageUrl;
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.published,
    required this.url,
    this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['article_id'],
      title: json['title'],
      published: DateTime.parse(json['pubDate']),
      url: json['link'],
      imageUrl: json['image_url'],
    );
  }
}
