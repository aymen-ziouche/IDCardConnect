import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/screens/auth/authgate.dart';
import 'package:nfc_id_reader/screens/auth/login.dart';
import 'package:nfc_id_reader/screens/auth/register.dart';
import 'package:nfc_id_reader/screens/home/homepage.dart';
import 'package:nfc_id_reader/screens/home/profilepage.dart';
import 'package:nfc_id_reader/screens/home/scancardpage.dart';
import 'package:provider/provider.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {});
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NFC ID READER',
        initialRoute: AuthGate.id,
        routes: {
          AuthGate.id: (context) => const AuthGate(),
          ScanCardPage.id: (context) => ScanCardPage(),
          Login.id: (context) => const Login(),
          Register.id: (context) => const Register(),
          ProfilePage.id: (context) => ChangeNotifierProvider(
              create: (_) => UserProvider(), child: ProfilePage()),
          HomePage.id: (context) => ChangeNotifierProvider(
              create: (_) => UserProvider(), child: const HomePage()),
        },
        theme: ThemeData(
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFF6006EE),
                style: BorderStyle.solid,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFF6006EE),
                style: BorderStyle.solid,
              ),
            ),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(
              color: Colors.black38,
            ),
            hintStyle: TextStyle(
              color: const Color(0xFF6006EE).withOpacity(0.4),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(10),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF6006EE)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          primaryColor: const Color(0xFF6006EE),
          canvasColor: Colors.white,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white,
          ),
        ));
  }
}
