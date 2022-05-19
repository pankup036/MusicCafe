import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:newmusic/screens/search.dart';
import 'package:newmusic/screens/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(188, 182, 36, 111),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const SearchPage()));
                },
                icon: const Icon(Icons.search)),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => const Settings()));
                  },
                  icon: const Icon(Icons.settings_outlined)),
            )
          ],
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: Text(
            'Music Cafe',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Color.fromARGB(255, 0, 128, 255),
                  Colors.black,
                ]),
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            // color: Color.fromARGB(188, 182, 36, 111),
          ),
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, allSongs) {
                if (allSongs.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (allSongs.data!.isEmpty) return const Text("Nothing found!");
                List<SongModel> songmodel = allSongs.data!;
                List<Audio> songs = [];
                for (var song in songmodel) {
                  songs.add(
                    Audio.file(
                      song.uri.toString(),
                      metas: Metas(
                        title: song.title,
                        artist: song.artist,
                        id: song.id.toString(),
                      ),
                    ),
                  );
                }
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
                    return ListView.builder(
                      itemCount: allSongs.data!.length,
                      itemBuilder: (context, index) {
                        String artist = songs[index].metas.artist.toString();

                        if (artist == "<unknown>" && artist == "") {
                          artist = "No artist";
                        } else {
                          artist = songs[index].metas.artist.toString();
                        }
                        bool isFav = false;
                        int? key;
                        for (var fav in favorites) {
                          if (songs[index].metas.title == fav.title) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListTile(
                            onTap: () {
                              play(songs, index);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => PlayerScreen(
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              
                              allSongs.data![index].title,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 12),maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(artist,maxLines: 1,overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white)),
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
                                      final snackBar = SnackBar(
                            backgroundColor: Colors.black45,
                            content: Container(
                              
                              child: const Text('Successfully Added To Favourites',style: TextStyle(color: Colors.white),)),
                            
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    dialogBox(
                                        context,
                                        int.parse(songs[index].metas.id!),
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
                              artworkFit: BoxFit.cover,
                              artworkHeight: 40,
                              artworkWidth: 40,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
        ));
  }
}
