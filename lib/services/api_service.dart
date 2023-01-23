import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix_2023_01/models/webtoon.dart';
import 'package:toonflix_2023_01/models/webtoon_detail.dart';
import 'package:toonflix_2023_01/models/webtoon_episode_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';
  static const String epsiodes = 'epsiodes';

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtooInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtooInstances.add(toon);
      }
      return webtooInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodeInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        final toonEpisode = WebtoonEpisodeModel.fromJson(episode);
        episodeInstances.add(toonEpisode);
      }
      return episodeInstances;
    }
    throw Error();
  }
}
