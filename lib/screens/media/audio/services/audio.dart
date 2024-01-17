import 'package:podcast_search/podcast_search.dart';

class AudioService{
  Future<List<Episode>?> searchPods() async {
    var search = Search();
    var results = await search.search('david wale feso', country: Country.nigeria, limit: 2);

    print(results.items.map((e) => e.feedUrl));
    var podcast = await Podcast.loadFeed(url: 'https://cricmediatech.podomatic.com/rss2.xml');

    return podcast.episodes;
    // }
  }

}