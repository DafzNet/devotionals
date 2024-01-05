import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotionals/utils/helpers/functions/shuffle.dart';
import 'package:devotionals/utils/models/vid.dart';

class VideoService {
  final CollectionReference _videosCollection =
      FirebaseFirestore.instance.collection('videos');

  Future<List<VideoData>> getVideosByViews(int count) async {
    try {
      QuerySnapshot querySnapshot = await _videosCollection
          .orderBy('views', descending: true) // Order by views in descending order
          .limit(count)
          .get();

      List<VideoData> videos = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Assuming your VideoData class has a factory constructor to create an instance from a map
        return VideoData.fromMap(data);
      }).toList();

      return videos;
    } catch (e) {
      // Handle errors here
      print('Error fetching videos: $e');
      return [];
    }
  }


  Future<void> addVideoData(VideoData videoData) async {
    await _videosCollection.doc(videoData.id).set(videoData.toMap());
  }

  Future<List<VideoData>> getAllVideoData() async {
    var querySnapshot = await _videosCollection.get();
    final vids =  querySnapshot.docs
        .map((doc) => VideoData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

      return shuffleVideos(vids);
  }

  Future<VideoData?> getVideoDataById(String videoId) async {
    var docSnapshot = await _videosCollection.doc(videoId).get();

    if (docSnapshot.exists) {
      return VideoData.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updateVideoData(VideoData videoData) async {
    await _videosCollection.doc(videoData.id.toString()).update(videoData.toMap());
  }

  Future<void> deleteVideoData(VideoData videoData) async {
    await _videosCollection.doc(videoData.id.toString()).delete();
  }

   Future<List<VideoData>> getVideosByCategory(String category) async {
    var querySnapshot =
        await _videosCollection.where('category', isEqualTo: category).get();

    return querySnapshot.docs
        .map((doc) => VideoData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// The function `getVideosByTags` retrieves a list of `VideoData` objects from a Firestore collection
  /// based on the provided tags.
  /// 
  /// Args:
  ///   tags (List<String>): A list of strings representing the tags to filter the videos by.
  /// 
  /// Returns:
  ///   a `Future` that resolves to a `List` of `VideoData` objects.
  Future<List<VideoData>> getVideosByTags(List<String> tags) async {
    var querySnapshot = await _videosCollection
        .where('tags', arrayContainsAny: tags)
        .get();

    return querySnapshot.docs
        .map((doc) => VideoData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<VideoData>> getVideosBySeries(String series) async {
    var querySnapshot =
        await _videosCollection.where('series', isEqualTo: series).get();

    return querySnapshot.docs
        .map((doc) => VideoData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<VideoData>> getVideosByPart(String part) async {
    var querySnapshot =
        await _videosCollection.where('part', isEqualTo: part).get();

    return querySnapshot.docs
        .map((doc) => VideoData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<VideoData>> getMostRecentVideos(int count) async {
    var querySnapshot = await _videosCollection
        .orderBy('time', descending: true)
        .limit(count)
        .get();

    return querySnapshot.docs
        .map((doc) => VideoData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
