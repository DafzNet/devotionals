import 'package:devotionals/utils/models/vid.dart';

class VideoRecommendationService {
  final List<VideoData> allVideos;

  VideoRecommendationService(this.allVideos);

  List<VideoData> getAllRecommendations(VideoData targetVideo, int count) {
    List<VideoData> seriesRecommendations = getRecommendationsBySeries(targetVideo, count);
    List<VideoData> categoryRecommendations = getRecommendationsByCategory(targetVideo, count);
    List<VideoData> tagsRecommendations = getRecommendationsByTags(targetVideo, count);

    // Combine recommendations from series, category, and tags
    List<VideoData> allRecommendations = [
      ...seriesRecommendations,
      ...categoryRecommendations,
      ...tagsRecommendations,
    ];

    // Deduplicate the recommendations (if the same video appears in multiple lists)
    Set<VideoData> uniqueRecommendations = Set<VideoData>.from(allRecommendations);

    // Convert back to a list and limit to the desired count
    return uniqueRecommendations.take(count).toList();
  }

  List<VideoData> getRecommendationsByTags(VideoData targetVideo, int count) {
    // Recommendation based on tags logic
    var recommendedVideos = allVideos.where((video) {
      return (video.id != targetVideo.id) &&
          (video.tags.any((tag) => targetVideo.tags.contains(tag)));
    }).toList();

    return _getTopRecommendations(recommendedVideos, targetVideo, count);
  }

  List<VideoData> getRecommendationsByCategory(VideoData targetVideo, int count) {
    // Recommendation based on category logic
    var recommendedVideos = allVideos.where((video) {
      return (video.id != targetVideo.id) && (video.category == targetVideo.category);
    }).toList();

    return _getTopRecommendations(recommendedVideos, targetVideo, count);
  }

  List<VideoData> getRecommendationsBySeries(VideoData targetVideo, int count) {
    if (targetVideo.series != null && targetVideo.series!.isNotEmpty) {
      // Recommendation based on series
      var recommendedVideos = allVideos.where((video) {
        return (video.id != targetVideo.id) && (video.series == targetVideo.series);
      }).toList();

      return _getTopRecommendations(recommendedVideos, targetVideo, count);
    } else {
      // Fallback to recommendations by tags if series is not available
      return getRecommendationsByTags(targetVideo, count);
    }
  }

  List<VideoData> _getTopRecommendations(
      List<VideoData> recommendedVideos, VideoData targetVideo, int count) {
    // Sort recommended videos by some relevance metric
    recommendedVideos.sort((a, b) =>
        calculateRelevance(targetVideo, a).compareTo(calculateRelevance(targetVideo, b)));

    // Return the top count recommendations
    return recommendedVideos.take(count).toList();
  }

  double calculateRelevance(VideoData targetVideo, VideoData recommendedVideo) {
    // Your relevance calculation logic, considering tags or other factors.
    // This is a simplified example; adjust based on your specific requirements.
    return targetVideo.tags
        .where((tag) => recommendedVideo.tags.contains(tag))
        .length
        .toDouble();
  }
}
