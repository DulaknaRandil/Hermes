import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart'; // Add this line

class FeaturedNewsTab extends StatefulWidget {
  const FeaturedNewsTab({Key? key}) : super(key: key);

  @override
  _FeaturedNewsTabState createState() => _FeaturedNewsTabState();
}

class _FeaturedNewsTabState extends State<FeaturedNewsTab> {
  late List<Article> articles = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    fetchArticles();
    initializeNotifications();
  }

  Future<void> fetchArticles() async {
    final response = await http.get(
      Uri.parse(
          'https://newsdata.io/api/1/latest?apikey=pub_39701bd702c6c299b8440a77fc96ca954d83b'),
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

      if (articles.isNotEmpty) {
        final article = articles.first;
        await showNotification(article.title, article.url);
      }
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<void> showNotification(String title, String url) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'News Update',
      title,
      platformChannelSpecifics,
      payload: url,
    );
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  shadowColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
