import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlayerScreen extends StatefulWidget {
  int? index = 0;
  List<SongModel>? songModel2;

  PlayerScreen({Key? key, this.index, this.songModel2}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final OnAudioRoom _audioRoom = OnAudioRoom();

    Color blueColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    List<SongModel> songmodel = [];
    if (widget.songModel2 == null) {
      _audioQuery.querySongs().then((value) {
        songmodel = value;
      });
    } else {
      songmodel = widget.songModel2!;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Now Playing",style: GoogleFonts.montserrat(color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold),),
          centerTitle: true,
          foregroundColor: Color.fromARGB(255, 254, 253, 253),
          backgroundColor:  Colors.black,
          elevation: 0,
        ),
        //backgroundColor: Color.fromARGB(188, 182, 36, 111),
        body: SafeArea(child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
            colors: 
            [
             Colors.black,
             Color.fromARGB(255, 0, 128, 255),
             Colors.black,
            ])
          ),
          child: assetsAudioPlayer.builderCurrent(
              builder: (context, Playing? playing) {
            return FutureBuilder<List<FavoritesEntity>>(
                future: _audioRoom.queryFavorites(
                  limit: 50,
                  reverse: false,
                  sortType: null, //  Null will use the [key] has sort.
                ),
                builder: (context, allFavourite) {
                  if (allFavourite.data == null) {
                    return const SizedBox();
                  }
                  // if (allFavourite.data!.isEmpty) {
                  //   return const SizedBox();
                  // }
                  List<FavoritesEntity> favorites = allFavourite.data!;
                  List<Audio> favSongs = [];

                  for (var fSongs in favorites) {
                    favSongs.add(Audio.file(fSongs.lastData,
                        metas: Metas(
                            title: fSongs.title,
                            artist: fSongs.artist,
                            id: fSongs.id.toString())));
                  }
                  bool isFav = false;
                  int? key;
                  for (var fav in favorites) {
                    if (playing!.playlist.current.metas.title == fav.title) {
                      isFav = true;
                      key = fav.key;
                    }
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Text(
                              '${playing!.playlist.current.metas.title}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 250,
                            width: 250,
                            child: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(12),
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                
                                size: 200,
                              ),
                              id: int.parse(playing.playlist.current.metas.id!),
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${playing.playlist.current.metas.artist}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          assetsAudioPlayer.builderRealtimePlayingInfos(
                              builder: (context, RealtimePlayingInfos? infos) {
                            if (infos == null) {
                              return const SizedBox();
                            }
                            //print('infos: $infos');
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: ProgressBar(
                                  timeLabelTextStyle:
                                      TextStyle(color: Colors.black),
                                  timeLabelType: TimeLabelType.remainingTime,
                                  baseBarColor: Colors.grey[300],
                                  progressBarColor: Colors.grey[500],
                                  thumbColor: Colors.grey[700],
                                  barHeight: 4,
                                  thumbRadius: 7,
                                  progress: infos.currentPosition,
                                  total: infos.duration,
                                  onSeek: (duration) {
                                    assetsAudioPlayer.seek(duration);
                                  },
                                ));
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    dialogBox(
                                        context,
                                        int.parse(
                                            playing.playlist.current.metas.id!),
                                        playing.playlist.currentIndex,
                                        songmodel);
                                  },
                                  icon: Icon(Icons.playlist_add,size: 22,)),
                              IconButton(
                                  onPressed: () {
                                    assetsAudioPlayer.previous();
                                  },
                                  icon: Icon(Icons.skip_previous_rounded,size: 35,color: Colors.white,)),
                              assetsAudioPlayer.builderIsPlaying(
                                  builder: (context, isPlaying) {
                                return IconButton(
                                    onPressed: () {
                                      assetsAudioPlayer.playOrPause();
                                    },
                                    icon: isPlaying
                                        ? Icon(Icons.pause,color: Colors.white,)
                                        : Icon(Icons.play_arrow_rounded, color: Colors.white,size: 40,));
                              }),
                              IconButton(
                                  onPressed: () {
                                    assetsAudioPlayer.next();
                                  },
                                  icon: Icon(Icons.skip_next_rounded,size: 35,color: Colors.white,)),
                              IconButton(
                                onPressed: () async {
                                  // _audioRoom.addTo(
                                  //   RoomType.FAVORITES,
                                  //   songmodel[playing.index]
                                  //       .getMap
                                  //       .toFavoritesEntity(),
                                  //   ignoreDuplicate: false, // Avoid the same song
                                  // );
                                  // bool isAdded = await _audioRoom.checkIn(
                                  //   RoomType.FAVORITES,
                                  //   songmodel[playing.index].id,
                                  // );
                                  // print('$isAdded');
                                  if (!isFav) {
                                    _audioRoom.addTo(
                                      RoomType.FAVORITES,
                                      songmodel[playing.index]
                                          .getMap
                                          .toFavoritesEntity(),
                                      ignoreDuplicate:
                                          false, // Avoid the same song
                                    );
                                  } else {
                                    _audioRoom.deleteFrom(
                                        RoomType.FAVORITES, key!);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_outline,
                                  size: 22,color: Colors.red,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
        )));
  }
}
