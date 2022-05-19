import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playlistInfo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Playlists extends StatefulWidget {
  Playlists({Key? key}) : super(key: key);

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    final OnAudioQuery _audioQuery = OnAudioQuery();

    //return Container();
    return Scaffold(
        backgroundColor: Color.fromARGB(188, 182, 36, 111),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: Text('Playlists',style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
                onPressed: () {
                  createPlaylistFrom(context, () {
                    setState(() {
                      
                    });
                  });
                },
                icon: Icon(Icons.playlist_add))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
            colors: 
            [
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
            child: FutureBuilder<List<PlaylistEntity>>(
                future: _audioRoom.queryPlaylists(),
                builder: (context, item) {
                  if (item.data == null || item.data!.isEmpty) {
                    return  Center(
                      child: Text('Nothing Found',style: GoogleFonts.montserrat(color: Colors.white),),
                    );
                  }

                  return ListView.separated(
                      itemBuilder: (ctx, index) => Slidable(
                            endActionPane: ActionPane(
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    dialog(context, item.data![index].key,item.data![index].playlistName);
                                  },
                                  backgroundColor: Colors.green.shade400,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: const Text(
                                'Do you really want to delete?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('NO'),
                              ),
                              TextButton(
                                  onPressed: () {
                                   setState(() {
                                     _audioRoom.deletePlaylist(item.data![index].key);
                                   Navigator.pop(context);
                                   });
                                    // Navigator.of(context).pushAndRemoveUntil(
                                    //     MaterialPageRoute(
                                    //         builder: (context) => const Home()),
                                    //     (Route<dynamic> route) => false);
                                  },
                                  child: const Text('YES')),
                            ],
                          ));
                                      // _audioRoom.deletePlaylist(
                                      //     item.data![index].key);
                                    });
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                              motion: ScrollMotion(),
                            ),
                            child: ListTile(
                            
                              onTap: () {
                                //final x = item.data[index].key;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => PlaylistInfo(
                                              title: item
                                                  .data![index].playlistName,
                                              songs: item
                                                  .data![index].playlistSongs,
                                              playlistKey:
                                                  item.data![index].key,
                                            )));
                                //final x = item.data![index].playlistSongs;
                                // print(x);
                                //list songs in playlist
                                // final x = item.data![index].;
                                // _audioRoom.addAllTo(RoomType.PLAYLIST, )
                                //print(item.data![index].dateAdded);
                                // final x = await _audioQuery.queryAudiosFrom(
                                //     AudiosFromType.PLAYLIST,
                                //     item.data![index].playlist);
                                // print(x);
                              },
                              contentPadding: EdgeInsets.only(left: 20),
                              title: Text(
                                item.data![index].playlistName,style: GoogleFonts.montserrat(color:Colors.white),
                              ),
                              leading: Icon(Icons.music_note,color: Colors.white,),
                            ),
                          ),
                      separatorBuilder: (ctx, index) => Divider(),
                      itemCount: item.data!.length);
                })));
  }

  void dialog(BuildContext context, int key,String playlistName) {

    var playlistNameController = TextEditingController();
    playlistNameController.text=playlistName;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx1) => AlertDialog(
              content: TextField(
                
                  controller: playlistNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //filled: true,
                    
                    hintStyle: TextStyle(color: Colors.grey[600]),
                   // hintText: playlistName,
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx1);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _audioRoom.renamePlaylist(
                            key, playlistNameController.text);
                      });
                      Navigator.pop(ctx1);
                      //createNewPlaylist(playlistNameController.text);

                      // dialogBox(context);
                    },
                    child: Text('Ok'))
              ],
            ));
  }
}
