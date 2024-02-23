// // import 'package:devotionals/screens/media/audio/services/audio.dart'
// import 'package:devotionals/screens/media/audio/services/my_audio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get_it/get_it.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:audio_service/audio_service.dart';

// GetIt getIt = GetIt.instance;

// class PageManager {
//   // Listeners: Updates going to the UI
//   final currentSongTitleNotifier = ValueNotifier<String>('');
//   final playlistNotifier = ValueNotifier<List<String>>([]);
//   final isFirstSongNotifier = ValueNotifier<bool>(true);
//   final isLastSongNotifier = ValueNotifier<bool>(true);
//   final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

//   final _audioHandler = getIt<AudioHandler>();
  

//   // Events: Calls coming from the UI
//   void init() async {
//      await _loadPlaylist();
//     _listenToChangesInPlaylist();
//     _listenToPlaybackState();
//     _listenToCurrentPosition();
//     _listenToBufferedPosition();
//     _listenToTotalDuration();
//     _listenToChangesInSong();
//   }

//   Future<void> _loadPlaylist() async {
    
//   }


//   void _listenToChangesInPlaylist() {
//     _audioHandler.queue.listen((playlist) {
//       if (playlist.isEmpty) {
//         playlistNotifier.value = [];
//         currentSongTitleNotifier.value = '';
//       } else {
//         final newList = playlist.map((item) => item.title).toList();
//         playlistNotifier.value = newList;
//       }
//       _updateSkipButtons();
//     });
//   }

//   void _listenToPlaybackState() {
//     _audioHandler.playbackState.listen((playbackState) {
//       final isPlaying = playbackState.playing;
//       final processingState = playbackState.processingState;
//       if (processingState == AudioProcessingState.loading ||
//           processingState == AudioProcessingState.buffering) {
//       } else if (!isPlaying) {
//       } else if (processingState != AudioProcessingState.completed) {
//       } else {
//         _audioHandler.seek(Duration.zero);
//         _audioHandler.pause();
//       }
//     });
//   }

//   void _listenToCurrentPosition() {
//     AudioService.position.listen((position) {
//     });
//   }

//   void _listenToBufferedPosition() {
//     _audioHandler.playbackState.listen((playbackState) {
//     });
//   }

//   void _listenToTotalDuration() {
//     _audioHandler.mediaItem.listen((mediaItem) {
//     });
//   }

//   void _listenToChangesInSong() {
//     _audioHandler.mediaItem.listen((mediaItem) {
//       currentSongTitleNotifier.value = mediaItem?.title ?? '';
//       _updateSkipButtons();
//     });
//   }

//   void _updateSkipButtons() {
//     final mediaItem = _audioHandler.mediaItem.value;
//     final playlist = _audioHandler.queue.value;
//     if (playlist.length < 2 || mediaItem == null) {
//       isFirstSongNotifier.value = true;
//       isLastSongNotifier.value = true;
//     } else {
//       isFirstSongNotifier.value = playlist.first == mediaItem;
//       isLastSongNotifier.value = playlist.last == mediaItem;
//     }
//   }

//   void play() => _audioHandler.play();
//   void pause() => _audioHandler.pause();

//   void seek(Duration position) => _audioHandler.seek(position);

//   void previous() => _audioHandler.skipToPrevious();
//   void next() => _audioHandler.skipToNext();

//   void repeat() {
    
//   }

//   void shuffle() {
//     final enable = !isShuffleModeEnabledNotifier.value;
//     isShuffleModeEnabledNotifier.value = enable;
//     if (enable) {
//       _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
//     } else {
//       _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
//     }
//   }

//   Future<void> add(Episode song) async {
//     AudioSource source = AudioSource.uri(Uri.parse(song.audioUrl));
//     final mediaItem = MediaItem(
//       id: song.audioUrl,
//       title: song.title,
//       artUri: Uri.parse(song.episodeImage),
//       artist: 'David Wale Feso',
//       duration: song.duration,
//       extras: {'url': song.audioUrl},
//     );
//     _audioHandler.addQueueItem(mediaItem);
//   }

//   void remove() {
//     final lastIndex = _audioHandler.queue.value.length - 1;
//     if (lastIndex < 0) return;
//     _audioHandler.removeQueueItemAt(lastIndex);
//   }

//   void dispose() {
//     _audioHandler.customAction('dispose');
//   }

//   void stop() {
//     _audioHandler.stop();
//   }
// }
