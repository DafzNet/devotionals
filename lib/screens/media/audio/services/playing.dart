import 'package:podcast_search/podcast_search.dart';

class Playing {
  static final Playing _instance = Playing._internal();
  Episode? _episode;

  factory Playing() {
    return _instance;
  }

  Playing._internal();

  Episode? get currentEpisode => _episode;

  set currentEpisode(Episode? episode) {
    _episode = episode;
  }
}