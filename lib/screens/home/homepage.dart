import 'package:flutter/material.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/screens/auth/login.dart';
import 'package:nfc_id_reader/screens/home/profilepage.dart';
import 'package:nfc_id_reader/screens/home/scancardpage.dart';
import 'package:nfc_id_reader/services/auth.dart';
import 'package:nfc_id_reader/widgets/homepagewidget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchUser();
  }

  final _auth = Auth();
  Future<void> _logout() async {
    try {
      await _auth.logout();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      debugPrint('logout error: $e');
    }
  }

  List<RiveAnimation> animations = const [
    RiveAnimation.asset('assets/avatar.riv'),
    RiveAnimation.asset('assets/cardswipe.riv'),
    RiveAnimation.asset('assets/powerbutton.riv')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "NfC ID Card Scanner",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                create: (_) => UserProvider(),
                                child: ProfilePage()),
                          ));
                    },
                    child: HomePageWidget("Profile ", animations[index]));
              } else if (index == 1) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScanCardPage()));
                    },
                    child: HomePageWidget("Scan Card ", animations[index]));
              } else {
                return GestureDetector(
                    onTap: _logout,
                    child:
                        HomePageWidgett("Logout ", Icons.power_settings_new));
              }
            },
          ),
        ],
      ),
    );
  }
}
