import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newmusic/screens/dialog.dart';


 bool notification = true;
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
 
  @override
  Widget build(BuildContext context) {
    bool notifications = true;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'Settings',
          style:GoogleFonts.montserrat(color: const Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration:const BoxDecoration(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              // ListTile(
              //   onTap: () {},
              //   leading: const Icon(Icons.account_circle_outlined),
              //   title: const Text('About'),
              // ),
              // Divider(),
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('Notifications'),textColor: Colors.white,
                trailing: Switch.adaptive(
                    value: notification,
                    onChanged: (value) {
                      setState(() {
                         notification = value;
                      });
                       print(notification);
                    }),
              ),
              const Divider(),
               ListTile(
                leading: Icon(Icons.report_rounded),
                title: Text('Privacy Policy'),textColor: Colors.white,
                onTap: (){
                  showDialog(
                            context: context,
                            builder: (context) {
                              return PolicyDialog(
                                  mdFileName: "privacy.md");
                            });
                }
              ),
              const Divider(),
               ListTile(
                leading: Icon(Icons.flag),
                title: Text('About Us'),textColor: Colors.white,
                onTap: (){
                  showAboutDialog(context: context,
                  applicationIcon:Icon(Icons.headphones,color: Colors.blueGrey,size: 50,),
                  applicationName: 'Music Cafe',
                  applicationVersion: '0.0.01',
                  applicationLegalese: 'Developed By Pankajakshan P',




                  );
                  

                },
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.verified),
                title: Text('Version'),textColor: Colors.white,
                trailing: Text('0.0.01'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
