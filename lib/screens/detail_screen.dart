import 'package:flutter/material.dart';
import 'package:toonflix_2023_01/models/webtoon_detail.dart';
import 'package:toonflix_2023_01/models/webtoon_episode_model.dart';
import 'package:toonflix_2023_01/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    print(webtoon);
    print(episodes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            50,
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.id,
                  child: Container(
                    width: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          offset: const Offset(10, 10),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    child: Image.network(widget.thumb),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder(
              future: webtoon,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${snapshot.data!.genre} / ${snapshot.data!.age}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }
                return const Text('....');
              },
            ),
            const SizedBox(
              height: 50,
            ),
            FutureBuilder(
              future: episodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data![0].title);
                  return Column(
                    children: [
                      for (var episode in snapshot.data!)
                        EpisiodeWidget(episode: episode)
                    ],
                  );
                }
                return Container();
              },
            )
          ]),
        ),
      ),
    );
  }
}

class EpisiodeWidget extends StatelessWidget {
  const EpisiodeWidget({
    super.key,
    required this.episode,
  });

  final WebtoonEpisodeModel episode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(2, 2),
            color: Colors.black.withOpacity(0.2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              episode.title,
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
