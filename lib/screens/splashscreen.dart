import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:newmusic/main.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> fetchedSongs = [];
  List<SongModel> allSongs = [];
  

  List <Audio>? fullsong;

@override
void initState(){
  home();
  //  requestPermission();
  super.initState();

}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(188, 182, 36, 111),
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Music Cafe',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.only(left: 70,right: 70,),
                
                child: Image.asset('Assets/images/flash.png'),
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                'Enjoy Unlimited Music',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30, color: Colors.white),
              )
            ],
          ),
        )));
  }
  Future<void>home()async{
    await Future.delayed(const Duration(seconds: 4),);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Home()));

  }
  // void requestPermission() async {
  //   bool requestpermission = await _audioQuery.permissionsStatus();
  //   if (!requestpermission) {
  //     _audioQuery.permissionsRequest();
  //   }
  //   setState(() {});
  //   fetchedSongs = await _audioQuery.querySongs();
  //   // for (var element in fetchedSongs) {
  //   //   if (element.fileExtension == "mp3") {
  //   //     allSongs.add(element);
  //   //   }
  //   // }
  //    setState(() {});
  //   //  allSongs.forEach((element) {fullsong!.add(Audio.file(element.id.toString(),
  //   //  metas: Metas(title: element.title,
  //   //           id: element.id.toString(),
  //   //           artist: element.artist))) ;});
  // }
  

 












}
