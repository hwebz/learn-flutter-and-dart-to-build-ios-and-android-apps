import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  String? duration;
  Timestamp? releaseDate;
  String? image;
  String? url;
  bool? isFavorite;
  String? songId;

  SongModel(
      {this.title,
      this.artist,
      this.duration,
      this.releaseDate,
      this.image,
      this.url,
      this.isFavorite,
      this.songId});

  SongModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    artist = json['artist'];
    duration = json['duration'];
    releaseDate = json['releaseDate'];
    image = json['image'];
    url = json['url'];
    isFavorite = json['isFavorite'];
    songId = json['songId'];
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
        title: title!,
        artist: artist!,
        duration: duration!,
        releaseDate: releaseDate!,
        image: image!,
        url: url!,
        isFavorite: isFavorite!,
        songId: songId!);
  }
}
