import 'dart:math';

import 'package:devotionals/utils/models/vid.dart';

List<VideoData> shuffleVideos(List<VideoData> videos) {
  var random = Random();

  for (var i = videos.length - 1; i > 0; i--) {
    var j = random.nextInt(i + 1);

    // Swap videos[i] and videos[j]
    var temp = videos[i];
    videos[i] = videos[j];
    videos[j] = temp;
  }

  return videos;
}
