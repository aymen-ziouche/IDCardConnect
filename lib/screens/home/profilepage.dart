import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/screens/auth/login.dart';
import 'package:nfc_id_reader/screens/home/cardpage.dart';
import 'package:nfc_id_reader/screens/home/editemail.dart';
import 'package:nfc_id_reader/screens/home/editpass.dart';
import 'package:nfc_id_reader/screens/home/editprofile.dart';
import 'package:nfc_id_reader/services/auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  static String id = "ProfilePage";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        if (provider.user == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
              strokeWidth: 5,
            ),
          );
        }
        String gender = provider.user!.cardGender;
        var arr = gender.split('.');
        print(arr);
        print("LONG TEXT TO DEBUG");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Profile Page"),
            actions: [
              PopupMenuButton(itemBuilder: (context) {
                return const [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Edit Name"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Edit password"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Edit email"),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text("Show Card"),
                  ),
                  PopupMenuItem<int>(
                    value: 4,
                    child: Text("Delete Profile"),
                  ),
                  PopupMenuItem<int>(
                    value: 5,
                    child: Text("Logout"),
                  ),
                ];
              }, onSelected: (value) {
                if (value == 0) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (_) => UserProvider(),
                            child: EditProfile(
                              myprovider: provider,
                            )),
                      ));
                } else if (value == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (_) => UserProvider(),
                            child: EditPassword(
                              myprovider: provider,
                            )),
                      ));
                } else if (value == 2) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                            create: (_) => UserProvider(),
                            child: EditEmail(
                              myprovider: provider,
                            )),
                      ));
                } else if (value == 3) {
                  provider.user!.date_of_birth.isEmpty
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You dont have any saved data"),
                          ),
                        )
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CardPage(
                                    myprovider: provider,
                                  )));
                } else if (value == 4) {
                  // Handle Delete Profile
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text(
                            "Are you sure you want to delete your profile?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () {
                              final _auth = Auth();
                              final user = _auth.currentUser;
                              user!.delete();

                              Navigator.pushReplacementNamed(context, Login.id);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (value == 5) {
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

                  _logout();
                }
              }),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 60.0),
            child: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Name:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          provider.user!.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Email :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          provider.user!.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Gender:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          arr[1],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Number:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          provider.user!.mobile,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  provider.user!.doc_num.isEmpty
                      ? Text(
                          "You Dont have any Saved Data",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Saved Data: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 150,
                              child: Image.memory(
                                  provider.user!.image as Uint8List),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "First Name:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.firstname,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Last Name:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.lastname,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Country:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.country,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Nationality:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.nationality,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Document code:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.doc_code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Document Number:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.doc_num,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Date of Birth:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.date_of_birth,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      "Date of expiry:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    provider.user!.date_of_expiry,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }
}
