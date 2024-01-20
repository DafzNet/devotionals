import 'package:devotionals/screens/media/audio/services/audio.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  bool isPlaying = false;
  bool isPaused = false;

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
    _audioPlayer.positionStream.listen((Duration position) {
    });

    _audioPlayer.durationStream.listen((Duration? duration) {
      // Handle total duration updates here
      if (duration != null) {
        
      }
    });
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
      shuffleOrder: DefaultShuffleOrder(),
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
  }

  Future<void> previous() async {
    await _audioPlayer.seekToPrevious();
  }

  Duration get totalDuration => _audioPlayer.duration ?? Duration.zero;

  Duration get currentPosition => _audioPlayer.position;

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

}
