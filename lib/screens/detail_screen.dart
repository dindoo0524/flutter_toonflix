import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      // likedToons 리스트에 해당 id 가 포함하는지 확인
      if (likedToons.contains(widget.id) == true) {
        isLiked = true;
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPref();
  }

  void onTapLike() async {
    // isLiked = !isLiked;
    // prefs.setStringList('likedToons', [...prefs.getStringList('key')])
    // final originList = prefs.getStringList('likedToons');
    // if (isLiked) {
    //   originList?.remove(widget.id);
    //   // likedToons 에서 remove
    // } else {
    //   originList?.add(widget.id);
    //   // likedToons 에서 add
    // }
    // await prefs.setStringList('likedToons', originList!);
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
        actions: [
          IconButton(
            onPressed: onTapLike,
            icon:
                Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_outline),
          )
        ],
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
                  return Column(
                    children: [
                      for (var episode in snapshot.data!)
                        EpisiodeWidget(episode: episode, webtoon_id: widget.id)
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
    required this.webtoon_id,
  });

  final WebtoonEpisodeModel episode;
  final String webtoon_id;

  // onButtonTap() async {
  //   await launchUrlString("~~")
  // webtoon id, episode id
  // }

  onButtonTap() {
    print("$webtoon_id/${episode.id}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
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
      ),
    );
  }
}
