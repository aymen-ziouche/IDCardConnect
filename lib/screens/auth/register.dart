import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/screens/auth/login.dart';
import 'package:nfc_id_reader/screens/home/homepage.dart';
import 'package:nfc_id_reader/screens/home/scancardpage.dart';
import 'package:nfc_id_reader/services/auth.dart';
import 'package:nfc_id_reader/widgets/mainButton.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static String id = "Register";

  @override
  State<Register> createState() => _RegisterState();
}

enum Gender {
  Male,
  Female,
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmpasswordFocusNode = FocusNode();
  final _auth = Auth();
  Gender? _selectedGender;

  bool _passwordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    const Color(0xff827397),
                    Theme.of(context).primaryColor,
                  ],
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      "Please enter your details to reister on the app",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _globalKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40.0),
                              TextFormField(
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailFocusNode),
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter your Full Name!'
                                    : null,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.user,
                                    size: 25,
                                  ),
                                  labelText: 'Name',
                                  hintText: 'Enter your Name!',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34.0),
                              TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_mobileFocusNode),
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter your email!'
                                    : null,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    size: 25,
                                  ),
                                  labelText: 'Email',
                                  hintText: 'Enter your email!',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34.0),
                              TextFormField(
                                controller: _mobileController,
                                focusNode: _mobileFocusNode,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter your Number!'
                                    : null,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    size: 25,
                                  ),
                                  labelText: 'Number',
                                  hintText: 'Enter your Number!',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34.0),
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter your password!'
                                    : null,
                                obscureText:
                                    !_passwordVisible, //This will obscure text dynamically

                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.lock,
                                    size: 25,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  labelText: 'Password',
                                  hintText: 'Enter your pasword!',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 34.0),
                              TextFormField(
                                controller: _confirmpasswordController,
                                focusNode: _confirmpasswordFocusNode,
                                validator: (val) {
                                  val!.isEmpty
                                      ? 'Please confirm password!'
                                      : null;
                                  val != _passwordController.text
                                      ? "Enter the right password"
                                      : null;
                                },
                                obscureText: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.lock,
                                    size: 25,
                                  ),
                                  labelText: 'confirm Password',
                                  hintText: 'confirm your pasword!',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gender',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio<Gender>(
                                        value: Gender.Male,
                                        groupValue: _selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                      ),
                                      Text('Male'),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Radio<Gender>(
                                        value: Gender.Female,
                                        groupValue: _selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                      ),
                                      Text('Female'),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, Login.id);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              MainButton(
                                text: "Register",
                                hasCircularBorder: true,
                                onTap: () async {
                                  if (_globalKey.currentState!.validate()) {
                                    _globalKey.currentState!.save();
                                    try {
                                      final authresult = await _auth.signUp(
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text,
                                        _mobileController.text,
                                        _selectedGender.toString(),
                                      );
                                      print(authresult.user!.email);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString(),
                                          ),
                                        ),
                                      );
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                                  create: (_) => UserProvider(),
                                                  child: const HomePage()),
                                        ));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
