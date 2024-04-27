import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:devotionals/utils/constants/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'manager.dart';

GetIt getIt = GetIt.instance;

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.cric.app.channel.audio',
      androidNotificationChannelName: 'Cric',
      androidShowNotificationBadge: true,
      androidNotificationIcon: 'mipmap/ic_launcher_notif',
      androidStopForegroundOnPause: false,
      notificationColor: cricColor.shade200,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final _epsodesList = getIt<Playlist>();
  Expando<MediaItem> songsExpando = Expando<MediaItem>();

  MyAudioHandler() {
    _init();
    // _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

   void _playbackError(err) {
  }



  void _init()async{
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    Rx.combineLatest4<int?, List<MediaItem>, bool, List<int>?, MediaItem?>(
        _player.currentIndexStream,
        queue,
        _player.shuffleModeEnabledStream,
        _player.shuffleIndicesStream,
        (index, queue, shuffleModeEnabled, shuffleIndices) {
      final queueIndex = getQueueIndex(
        index,
        shuffleIndices,
        shuffleModeEnabled: shuffleModeEnabled,
      );
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex]
          : null;
    }).whereType<MediaItem>().distinct().listen(mediaItem.add);

    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream
        .listen(_broadcastState, onError: _playbackError);

    _player.shuffleModeEnabledStream
        .listen((enabled) => _broadcastState(_player.playbackEvent));

    _player.loopModeStream
        .listen((event) => _broadcastState(_player.playbackEvent));

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
        _player.seek(Duration.zero, index: 0);
      }
    });
  }

  int? getQueueIndex(
    int? currentIndex,
    List<int>? shuffleIndices, {
    bool shuffleModeEnabled = false,
  }) {
    final effectiveIndices = _player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    late List<int> preferredCompactNotificationButtons = [1, 2, 3];

    final queueIndex = getQueueIndex(
      event.currentIndex,
      _player.shuffleIndices,
      shuffleModeEnabled: _player.shuffleModeEnabled,
    );
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          // workaround to add like button
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          if (!Platform.isIOS) MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: preferredCompactNotificationButtons,
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: queueIndex,
      ),
    );
  }


  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  // void _listenForCurrentSongIndexChanges() {
  //   _player.currentIndexStream.listen((index) {
  //     final playlist = queue.value;
  //     if (index == null || playlist.isEmpty) return;
  //     if (_player.shuffleModeEnabled) {
  //       index = _player.shuffleIndices!.indexOf(index);
  //     }
  //     mediaItem.add(playlist[index]);
  //   });
  // }

  void _listenForCurrentSongIndexChanges() {
  _player.currentIndexStream.listen((index) {
    final playlist = queue.value;
    if (index == null || playlist.isEmpty) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices!.indexOf(index);
    }
    final currentMediaItem = playlist[index];
    mediaItem.add(currentMediaItem); // Emit the new MediaItem through the stream
    // Update the playback state with the new queue index and other details
    _broadcastState(_player.playbackEvent);
  });
}



  void _listenForSequenceStateChanges() {
  _player.sequenceStateStream.listen((SequenceState? sequenceState) {
    final sequence = sequenceState?.effectiveSequence;
    if (sequence == null || sequence.isEmpty) return;
    final items = sequence
        .where((source) => source.tag is MediaItem)
        .map((source) => source.tag as MediaItem);
    queue.add(items.toList(growable: false));
    });
  }


  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final newQueue = queue.value..addAll(mediaItems);
    _playlist.addAll(_createAudioSources(mediaItems));
    queue.add(newQueue);
    _player.setAudioSource(_playlist,);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);
    songsExpando[audioSource] = mediaItem;
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  AudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(Uri.parse(mediaItem.extras!['url']));
  }

  List<AudioSource> _createAudioSources(List<MediaItem> mediaItems) {
    return mediaItems.map(
      (e){
        final audioSource = _createAudioSource(e);
        songsExpando[audioSource] = e;
        return audioSource;}).toList();
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
