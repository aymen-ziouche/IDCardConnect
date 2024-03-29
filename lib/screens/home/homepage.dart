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
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const snackBar = SnackBar(
        content: Text('user logged in successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
          "NfC ID Card Reader",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 2,
            // ),
            padding: EdgeInsets.all(10),
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmation"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("logout"),
                                onPressed: () {
                                  final _auth = Auth();
                                  final user = _auth.currentUser;
                                  Future<void> _logout() async {
                                    try {
                                      await _auth.logout();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } catch (e) {
                                      debugPrint('logout error: $e');
                                    }
                                  }

                                  _logout();

                                  Navigator.pushReplacementNamed(
                                      context, Login.id);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
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
