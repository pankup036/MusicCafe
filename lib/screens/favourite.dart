import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Favourite extends StatefulWidget {
  Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    final OnAudioQuery _audioQuery = OnAudioQuery();
    final OnAudioRoom _audioRoom = OnAudioRoom();

    //return Container();
    return Scaffold(
        backgroundColor: const Color.fromARGB(188, 182, 36, 111),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title:  Text('Favourite',style: GoogleFonts.montserrat(color: Colors.white),),
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
            child: FutureBuilder<List<FavoritesEntity>>(
                future: _audioRoom.queryFavorites(
                  // limit: 50,
                  reverse: false,
                  // sortType: null,
                ),
                builder: (context, item) {
                  if (item.data == null || item.data!.isEmpty) {
                    return const Center(
                      child: Text('Nothing Found'),
                    );
                  }
                  List<FavoritesEntity> favorites = item.data!;
                  List<Audio> favSongs = [];
                  for (var songs in favorites) {
                    favSongs.add(Audio.file(songs.lastData,
                        metas: Metas(
                            title: songs.title,
                            artist: songs.artist,
                            id: songs.id.toString())));
                  }
                  return ListView.separated(
                      itemBuilder: (ctx, index) => Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      setState(() {
                                        _audioRoom.deleteFrom(
                                            RoomType.FAVORITES,
                                            favorites[index].key);
                                            
                                      });
                                      final snackBar = SnackBar(
                            backgroundColor: Colors.black45,
                            content: Container(
                              
                              child: const Text('Deleted From Favourites',style: TextStyle(color: Colors.white),)),
                            
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      // bool isAdded = await _audioRoom.checkIn(
                                      //   RoomType.FAVORITES,
                                      //   favorites[index].key,
                                      // );
                                      // print('$isAdded');
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ]),
                            child: ListTile(
                              onTap: () {
                                play(favSongs, index);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => PlayerScreen()));
                              },
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              title: Text(
                                favorites[index].title,
                                style:
                                    GoogleFonts.montserrat(color: Colors.white,fontSize: 12,),
                              ),
                              leading: QueryArtworkWidget(
                                id: favorites[index].id,
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
                            ),
                          ),
                      separatorBuilder: (ctx, index) => const SizedBox(height: 5,),
                      itemCount: item.data!.length);
                })));
  }
}
