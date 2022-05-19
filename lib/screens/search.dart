// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  String searchTerm = '';
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: const Text('Music Cafe'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient:  const LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
            colors: 
            [
             Colors.black,
             const Color.fromARGB(255, 0, 128, 255),
             Colors.black,
            ]),
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            // color: Colors.grey[200],
          ),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                ),
              ),
              Expanded(
                  child: (searchTerm.isEmpty)
                      ? FutureBuilder<List<SongModel>>(
                          future: _audioQuery.querySongs(
                            sortType: null,
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, allSongs) {
                            if (allSongs.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (allSongs.data!.isEmpty) {
                              return const Text("Nothing found!");
                            }

                            List<SongModel> songmodel = allSongs.data!;

                            List<Audio> songs = [];

                            for (var song in songmodel) {
                              songs.add(Audio.file(song.uri.toString(),
                                  metas: Metas(
                                      title: song.title,
                                      artist: song.artist,
                                      id: song.id.toString())));
                            }

                            return FutureBuilder<List<FavoritesEntity>>(
                              future: _audioRoom.queryFavorites(
                                limit: 50,
                                reverse: false,
                                sortType:
                                    null, //  Null will use the [key] has sort.
                              ),
                              builder: (context, allFavourite) {
                                if (allFavourite.data == null) {
                                  return const SizedBox();
                                }
                                // if (allFavourite.data!.isEmpty) {
                                //   return const SizedBox();
                                // }
                                List<FavoritesEntity> favorites =
                                    allFavourite.data!;
                                List<Audio> favSongs = [];

                                for (var fSongs in favorites) {
                                  favSongs.add(Audio.file(fSongs.lastData,
                                      metas: Metas(
                                          title: fSongs.title,
                                          artist: fSongs.artist,
                                          id: fSongs.id.toString())));
                                }
                                return ListView.builder(
                                  itemCount: allSongs.data!.length,
                                  itemBuilder: (context, index) {
                                    bool isFav = false;
                                    int? key;
                                    for (var fav in favorites) {
                                      if (songs[index].metas.title ==
                                          fav.title) {
                                        isFav = true;
                                        key = fav.key;
                                      }
                                    }
                                    // int key = 0;
                                    // for (var ff in favorites) {
                                    //   if (songs[index].metas.id == ff.) {
                                    //     isFav = true;
                                    //     key = ff.key;
                                    //   }
                                    // }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ListTile(
                                        onTap: () {
                                          play(songs, index);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      PlayerScreen(
                                                        index: index,
                                                      )));
                                        },
                                        title:
                                            Text(allSongs.data![index].title,
                                            style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                            
                                            
                                            ),
                                        subtitle: Text(
                                          
                                            allSongs.data![index].artist ??
                                                "No Artist",
                                                style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                                
                                                ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                // print(isFav);
                                                if (!isFav) {
                                                  _audioRoom.addTo(
                                                    RoomType
                                                        .FAVORITES, // Specify the room type
                                                    songmodel[index]
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
                                                // bool isAdded = await _audioRoom.checkIn(
                                                //   RoomType.FAVORITES,
                                                //   songmodel[index].id,
                                                // );
                                                // print('...................$isAdded');
                                              },
                                              icon: Icon(
                                                isFav
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 18,color: Colors.red,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                dialogBox(
                                                    context,
                                                    int.parse(
                                                        songs[index].metas.id!),
                                                    index,
                                                    songmodel);
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                              ),
                                            )
                                          ],
                                        ),
                                        leading: QueryArtworkWidget(
                                          //nullArtworkWidget: Icon(Icons.music_note),
                                          id: allSongs.data![index].id,
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: ClipRRect(
                                  child: Image.asset(
                                    "Assets/images/flash.png",
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                        ),
                                      ),
                                    ));
                                  },
                                );
                              },
                            );
                          })
                      : FutureBuilder<List<SongModel>>(
                          future: _audioQuery.querySongs(
                            sortType: null,
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, allSongs) {
                            if (allSongs.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (allSongs.data!.isEmpty) {
                              return const Text("Nothing found!");
                            }

                            List<SongModel> songmodel = allSongs.data!;

                            List<SongModel> songModelList = songmodel
                                .where((song) => song.title
                                    .toLowerCase()
                                    .contains(searchTerm))
                                .toList();

                            List<Audio> songs = [];

                            for (var song in songModelList) {
                              songs.add(Audio.file(song.uri.toString(),
                                  metas: Metas(
                                      title: song.title,
                                      artist: song.artist,
                                      id: song.id.toString())));
                            }

                            return FutureBuilder<List<FavoritesEntity>>(
                                future: _audioRoom.queryFavorites(
                                  limit: 50,
                                  reverse: false,
                                  sortType:
                                      null, //  Null will use the [key] has sort.
                                ),
                                builder: (context, allFavourite) {
                                  if (allFavourite.data == null) {
                                    return const SizedBox();
                                  }
                                  // if (allFavourite.data!.isEmpty) {
                                  //   return const SizedBox();
                                  // }
                                  List<FavoritesEntity> favorites =
                                      allFavourite.data!;
                                  List<Audio> favSongs = [];

                                  for (var fSongs in favorites) {
                                    favSongs.add(Audio.file(fSongs.lastData,
                                        metas: Metas(
                                            title: fSongs.title,
                                            artist: fSongs.artist,
                                            id: fSongs.id.toString())));
                                  }
                                  return ListView.builder(
                                    itemCount: songs.length,
                                    itemBuilder: (context, index) {
                                      bool isFav = false;
                                      int? key;
                                      for (var fav in favorites) {
                                        if (songs[index].metas.title ==
                                            fav.title) {
                                          isFav = true;
                                          key = fav.key;
                                        }
                                      }
                                      // bool isFav = false;
                                      // int? key;
                                      // for (var fav in favorites) {
                                      //   if (songs[index].metas.title ==
                                      //       fav.title) {
                                      //     isFav = true;
                                      //     key = fav.key;
                                      //   }
                                      // }
                                      // int key = 0;
                                      // for (var ff in favorites) {
                                      //   if (songs[index].metas.id == ff.) {
                                      //     isFav = true;
                                      //     key = ff.key;
                                      //   }
                                      // }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ListTile(
                                          onTap: () {
                                            play(songs, index);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        PlayerScreen(
                                                          index: index,
                                                          songModel2:
                                                              songModelList,
                                                        )));
                                          },
                                          title:
                                              Text(songs[index].metas.title!),
                                          subtitle: Text(
                                              songs[index].metas.artist ??
                                                  "No Artist"),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  // print(isFav);
                                                  if (!isFav) {
                                                    _audioRoom.addTo(
                                                      RoomType
                                                          .FAVORITES, // Specify the room type
                                                      songModelList[index]
                                                          .getMap
                                                          .toFavoritesEntity(),
                                                      ignoreDuplicate:
                                                          false, // Avoid the same song
                                                    );
                                                  } else {
                                                    _audioRoom.deleteFrom(
                                                        RoomType.FAVORITES,
                                                        key!);
                                                  }
                                                  setState(() {});
                                                  // bool isAdded = await _audioRoom.checkIn(
                                                  //   RoomType.FAVORITES,
                                                  //   songmodel[index].id,
                                                  // );
                                                  // print('...................$isAdded');
                                                },
                                                icon: Icon(
                                                  isFav
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                                  size: 18,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  dialogBox(
                                                      context,
                                                      int.parse(songs[index]
                                                          .metas
                                                          .id!),
                                                      index,
                                                      songModelList);
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                ),
                                              ),
                                            ],
                                          ),
                                          leading: QueryArtworkWidget(
                                            nullArtworkWidget: ClipRRect(
                                  child: Image.asset(
                                    "Assets/images/flash.png",
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                        ),
                                            id: int.parse(
                                                songs[index].metas.id!),
                                            type: ArtworkType.AUDIO,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                          })),
            ],
          ),
        ));
  }
}
