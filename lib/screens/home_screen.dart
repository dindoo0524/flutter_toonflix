import 'package:flutter/material.dart';
import 'package:toonflix_2023_01/models/webtoon_model.dart';
import 'package:toonflix_2023_01/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodayToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 웹툰', style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var webtoon = webtoons[index];

              return null;
            },
            itemCount: 10,
          ),
        ),
      ]),
    );
  }
}
