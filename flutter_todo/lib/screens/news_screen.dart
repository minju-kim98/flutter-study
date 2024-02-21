import 'package:flutter/material.dart';
import 'package:flutter_todo/models/news.dart';
import 'package:flutter_todo/providers/news_api.dart';
import 'package:flutter_todo/screens/list_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsApi newsApi = NewsApi();
  List<News> news = [];
  bool isLoading = true;

  Future initNews() async {
    news = await newsApi.getNews();
  }

  @override
  void initState() {
    super.initState();
    initNews().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackKey();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('뉴스 화면'),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ListScreen()));
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle),
                    Text('할 일'),
                  ],
                ),
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: news.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    news[index].title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    news[index].description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _onBackKey() async {
    return await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: const Color(0xff161619),
          title: const Text(
            '끝내시겠습니까?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('끝내기'),),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('아니요'),
            )
          ],
      );
    });
  }
}
