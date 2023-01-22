import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix_2023_01/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';

  static Future<List<WebtoonModel>> getTodayToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final respose = await http.get(url);
    if (respose.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(respose.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }

    throw Error();
  }
}
