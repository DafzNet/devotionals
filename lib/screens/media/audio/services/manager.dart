import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  bool isPlaying = false;
  bool isPaused = false;


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



  Future<void> play(String url) async {
    await _audioPlayer.setUrl(url);
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
    // Implement logic to play the next song
    // For simplicity, you can stop the current song and play a new one.
    // You may want to implement a playlist or track index management based on your requirements.
    await stop(); 
    // Play the next song, replace 'https://example.com/next_song.mp3' with the actual URL.
    await play('https://example.com/next_song.mp3');
  }

  Future<void> previous() async {
    await stop();
    await play('https://example.com/prev_song.mp3');
  }

  Duration get totalDuration => _audioPlayer.duration ?? Duration.zero;

  Duration get currentPosition => _audioPlayer.position;

  AudioPlayer get audioPlayer => _audioPlayer;

  // Add a method to release resources when the AudioManager is no longer needed
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

}
