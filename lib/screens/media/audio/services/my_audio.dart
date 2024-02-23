// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:podcast_search/podcast_search.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class Podcast {
  late String title;
  late String description;
  late String link;
  late String image;
  late List<Episode> episodes;

  Podcast(this.title, this.description, this.link, this.image, this.episodes);

  factory Podcast.fromXml(String xmlData) {
    final document = XmlDocument.parse(xmlData);
    final rss = document.findElements('rss').first;
    
    final c = rss.findElements('channel');
    final channel = c.first;
    var podcastTitle = channel.findElements('title').first.text;
    var podcastDescription = channel.findElements('description').first.text;
    var podcastLink = channel.findElements('link').first.text;
    var podcastImage = channel.findElements('image').first.text;

    var episodeElements = channel.findAllElements('item');
    var episodes = episodeElements.map((episode) {
      var title = episode.findElements('title').first.text;
      var description = episode.findElements('description').first.text;
      var author = episode.findElements('dc:creator').first.text;
      var link = episode.findElements('link').first.text;
      var enclosure = episode.findElements('enclosure').first;
      var audioUrl = enclosure.getAttribute('url') ?? '';
      var duration = episode.findElements('itunes:duration').first.text;
      var pubDate = episode.findElements('pubDate').first.text;
      var episodeImage = 'https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2584551/2584551-1615865658313-890f00870f672.jpg' ;

      return Episode(title, description, author, link, audioUrl, duration, pubDate, episodeImage);
    }).toList();

    return Podcast(podcastTitle, podcastDescription, podcastLink, podcastImage, episodes);
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'image': image,
      'episodes': episodes.map((episode) => episode.toMap()).toList(),
    };
  }

  factory Podcast.fromMap(Map<String, dynamic> map) {
    return Podcast(
      map['title'] ?? '',
      map['description'] ?? '',
      map['link'] ?? '',
      map['image'] ?? '',
      (map['episodes'] as List<Map<String, dynamic>>?)
          ?.map((episodeMap) => Episode.fromMap(episodeMap))
          .toList() ??
          [],
    );
  }
}

class Episode {
  late String title;
  late String description;
  late String author;
  late String link;
  late String audioUrl;
  late Duration duration; // Change the type to Duration
  late String pubDate;
  late String episodeImage;

  Episode(this.title, this.description, this.author, this.link, this.audioUrl, String duration, this.pubDate, this.episodeImage) {
    this.duration = _parseDuration(duration);
  }

  // Helper method to parse duration from a string
  Duration _parseDuration(String durationString) {
    
    List<String> parts = durationString.split(':');
    if (parts.length == 3) {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2].split('.')[0]);

      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      // Handle invalid duration string, returning a default duration of 0 seconds
      return Duration(seconds: 0);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'audioUrl': audioUrl,
      'duration': duration.toString(),
      'pubDate': pubDate,
      'episodeImage': episodeImage,
      'author': author,
    };
  }

  factory Episode.fromMap(Map<String, dynamic> map) {
    return Episode(
      map['title'] ?? '',
      map['description'] ?? '',
      map['author'] ?? '',
      map['link'] ?? '',
      map['audioUrl'] ?? '',
      map['duration'] ?? '',
      map['pubDate'] ?? '',
      map['episodeImage'] ?? '',
      
    );
  }

  @override
  bool operator ==(covariant Episode other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.description == description &&
      other.author == author &&
      other.link == link &&
      other.audioUrl == audioUrl &&
      other.duration == duration;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      description.hashCode ^
      author.hashCode ^
      link.hashCode ^
      audioUrl.hashCode ^
      duration.hashCode ^
      pubDate.hashCode ^
      episodeImage.hashCode;
  }
}


class AudService{
  Future<List<Episode>?> searchPods() async {
  var rssFeedUrl = 'https://anchor.fm/s/10004cbc/podcast/rss';
  var response = await http.get(Uri.parse(rssFeedUrl));

  if (response.statusCode == 200) {
    String xmlData =  utf8.decode(response.bodyBytes);
    Podcast podcast = Podcast.fromXml(xmlData);

    return podcast.episodes;
    }
  }

}