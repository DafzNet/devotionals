// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/screens/media/audio/services/my_audio.dart';


final GetIt getIt = GetIt.instance;

final _audioHandler = getIt<AudioHandler>();


class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  bool isPlaying = false;
  bool isPaused = false;
  bool isBuffering = false;
  final _storePlaylist = DataStore('playlist');
  final _storeFavorite = DataStore('favorites');
  final _storeSettings = DataStore('music_settings');

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
  }


  Future<void> addOrRemoveFavorite(Episode episode)async{
    if (await _storeFavorite.containsKey(episode.title+episode.audioUrl)) {
      await _storeFavorite.delete(episode.title+episode.audioUrl);
    } else {
      await _storeFavorite.insert(episode.title+episode.audioUrl, episode.toMap());
    }
  }

  Future<List<Episode>> getFavorites()async{
      final favs = await _storeFavorite.getAll();
      return favs.map((e) => Episode.fromMap(e!)).toList();
  }

  Future<bool> isFavorited(Episode episode)async{
    return await _storeFavorite.containsKey(episode.title+episode.audioUrl);
  }

  //Handling playlists
  Future<void> createPlaylist(String playlistTitle)async{
    ///The playlistTitle
    await _storePlaylist.insertList(playlistTitle, [{'name':playlistTitle}]);
  }

  Future<void> getPlaylists()async{
    await _storePlaylist.getAll();
  }


  Future<void> setPlaylist(Playlist playlist) async{
    List<MediaItem> mediaItems = playlist.songs.map((e) => MediaItem(
        id: playlist.songs.indexOf(e).toString(), 
        title: e.title,
        album: playlist.title,
        artist: 'Apostle David Wale Feso',
        artUri: Uri.parse(e.episodeImage),
        duration: e.duration,
        displayTitle: e.title,
        extras: {
          'url':e.audioUrl
        }
      )
    ).toList(growable: false);

    await _audioHandler.addQueueItems(mediaItems);
    
  }
}


class Playlist {
  String title;
  int initIndex;
  List<Episode> songs;
  Playlist({
    required this.title,
    this.initIndex = 0,
    required this.songs,
  });

  Playlist copyWith({
    String? title,
    int? initIndex,
    List<Episode>? songs,
  }) {
    return Playlist(
      title: title ?? this.title,
      initIndex: initIndex ?? this.initIndex,
      songs: songs ?? this.songs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'initIndex': initIndex,
      'songs': songs.map((x) => x.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      title: map['title'] as String,
      initIndex: map['initIndex'] as int,
      songs: List<Episode>.from((map['songs'] as List).map<Episode>((x) => Episode.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) => Playlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Playlist(title: $title, initIndex: $initIndex, songs: $songs)';

  @override
  bool operator ==(covariant Playlist other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.initIndex == initIndex &&
      listEquals(other.songs, songs);
  }

  @override
  int get hashCode => title.hashCode ^ initIndex.hashCode ^ songs.hashCode;
}
