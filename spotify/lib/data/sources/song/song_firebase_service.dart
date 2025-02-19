import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewSongs();
  Future<Either> getPlaylists();
  Future<Either> addOrRemoveFavoriteSong(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
}

class SongFirebaseServiceImpl implements SongFirebaseService {
  @override
  Future<Either> getNewSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(3)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>()
            .call(params: element.reference.id);
        songModel.songId = element.reference.id;
        songModel.isFavorite = isFavorite;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> getPlaylists() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: false)
          .limit(5)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>()
            .call(params: element.reference.id);
        songModel.songId = element.reference.id;
        songModel.isFavorite = isFavorite;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uid = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uid)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uid)
            .collection('Favorites')
            .add({
          'songId': songId,
          'addedDate': Timestamp.now(),
        });
        isFavorite = true;
      }

      return Right(isFavorite);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uid = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uid)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      return favoriteSongs.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      List<SongEntity> favoriteSongs = [];
      var user = firebaseAuth.currentUser;
      String uid = user!.uid;

      QuerySnapshot favoritesSnapshot = await firebaseFirestore
          .collection('Users')
          .doc(uid)
          .collection('Favorites')
          .get();

      for (var element in favoritesSnapshot.docs) {
        String songId = element['songId'];
        var song =
            await firebaseFirestore.collection('Songs').doc(songId).get();
        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(songModel.toEntity());
      }

      return Right(favoriteSongs);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }
}
