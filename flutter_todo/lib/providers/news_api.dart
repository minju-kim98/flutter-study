import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_todo/models/news.dart';
import 'package:http/http.dart' as http;

class NewsApi{
  static String apiUri = "https://newsapi.org/v2/top-headlines?country=kr&apikey=";
  static String apiKey = dotenv.get("NEWS_API_KEY");

  Uri uri = Uri.parse(apiUri + apiKey);

  Future<List<News>> getNews() async{
    List<News> news = [];
    final response = await http.get(uri);
    final statusCode = response.statusCode;
    final body = response.body;

    if(statusCode == 200){
      news = jsonDecode(body)['articles'].map<News>((article){
        return News.fromMap(article);
      }).toList();
    }

    return news;
  }
}