import 'package:audio_service/audio_service.dart';

import 'manager.dart';

class AudioPlayerHandler extends BaseAudioHandler
  with QueueHandler, SeekHandler{
  final AudioManager _player = AudioManager();

  @override
  Future<void> play() async {
    await _player.resume();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    // await super.onStop();
  }
}
