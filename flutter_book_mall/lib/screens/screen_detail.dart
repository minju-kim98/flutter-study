import 'package:flutter/material.dart';
import 'package:flutter_book_mall/models/model_item.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Item;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Container(
        child: ListView(
          children: [
            Image.network(item.imageUrl),
            Padding(
              padding: EdgeInsets.all(3),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Text(
                item.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        NumberFormat('#,###').format(item.price) + '원',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      Text(
                        '브랜드 : ' + item.brand,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '등록일자 : ' + item.registerDate,
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                        Text(
                          '담기',
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                item.description,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
