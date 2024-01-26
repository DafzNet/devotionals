import 'package:devotionals/dbs/sembast/generic.dart';
import 'package:devotionals/screens/media/audio/services/audio.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
final GetIt getIt = GetIt.instance;
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  bool isPlaying = false;
  bool isPaused = false;
  bool isBuffering = false;
  final _storePlaylist = DataStore('playlist');
  final _storeFavorite = DataStore('favorites');
  final _storeSettings = DataStore('music_settings');

  final Playing _playing = getIt<Playing>();

  Episode? _next;
  Episode? _prev;

  List<Episode> _playList = [];
  late AudioPlayer _audioPlayer;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    _audioPlayer = AudioPlayer();
    _initListeners();
  }

    void _initListeners() {

    _audioPlayer.playerStateStream.listen((PlayerState state) async {
      if (state.playing) {
        isBuffering = false;
        print('playing');
      } else {
        switch (state.processingState) {
          case ProcessingState.idle:
            isBuffering = false;
            print('idle');
            break;
          case ProcessingState.loading:
            isBuffering = true;
            print('load');
            break;
          case ProcessingState.buffering:
            isBuffering = true;
            print('buff');
            break;
          case ProcessingState.ready:
            isBuffering = false;
            print('rewdy');
            break;
          case ProcessingState.completed:
            isBuffering = false;
            print('complete');
            await next();
            break;
        }
      }
    });
  }

  //Handling favorites

  Future<void> addOrRemoveFavorite(Episode episode)async{
    if (await _storeFavorite.containsKey(episode.title+episode.audioUrl)) {
      await _storeFavorite.delete(episode.title+episode.audioUrl);
    } else {
      await _storeFavorite.insert(episode.title+episode.audioUrl, episode.toMap());
    }
  }

  Future<List<Episode>> getFavorites()async{
      final favs = await _storeFavorite.getAll();
      print(favs);
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





  var myplaylist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: []
  );


  List<Episode> get playlist => _playList;

  set playlist(List<Episode> newPlaylist) {
    _playList = newPlaylist;
    myplaylist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: _playList.map((e) => AudioSource.uri(Uri.parse(e.audioUrl))).toList(),
    );
  }



  Future<void> play(Episode episode) async {
    int? _init;
    for (var element in _playList) {
      if (element == episode) {
       _init = _playList.indexOf(element);
      }
    }

    _next = _playList[_init!+1];
    _prev = _playList[_init-1];

    _audioPlayer.setAudioSource(myplaylist, initialIndex: _init, initialPosition: Duration.zero);
    isPlaying = true;
    isPaused = false;
    await _audioPlayer.play();
    
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    isPlaying = false;
    isPaused = true;
  }

  Future<void> resume() async {
    isPlaying = true;
    isPaused = false;
    await _audioPlayer.play();

  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    isPlaying = false;
    isPaused = false;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> next() async {
    await _audioPlayer.seekToNext();
    _playing.currentEpisode = _next;
    _next = _playList[_playList.indexOf(_next!)+1];
    _prev = _playList[_playList.indexOf(_prev!)+1];
  }

  Future<void> previous() async {
    await _audioPlayer.seekToPrevious();
     _playing.currentEpisode = _prev;
    _prev = _playList[_playList.indexOf(_prev!)-1];
    _next = _playList[_playList.indexOf(_next!)-1];
  }



  Duration get totalDuration => _audioPlayer.duration ?? Duration.zero;

  Duration get currentPosition => _audioPlayer.position;

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

}
