import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/services/database.dart';
import 'package:nfc_id_reader/widgets/mainButton.dart';
import 'package:provider/provider.dart';

class EditPassword extends StatefulWidget {
  UserProvider myprovider;
  EditPassword({super.key, required this.myprovider});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final db = Database();
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newpasswordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _newpasswordFocusNode = FocusNode();
  bool _passwordVisible = false;
  bool _confpasswordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    _confpasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 34.0),
                  const Text(
                    "Update your Password: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 68.0),
                  TextFormField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your email!';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(val)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        size: 25,
                      ),
                      labelText: 'Email',
                      hintText: 'Please enter your email!',
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
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your password!' : null,
                    obscureText: !_passwordVisible,
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
                    controller: _newpasswordController,
                    focusNode: _newpasswordFocusNode,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your new password!' : null,
                    obscureText: !_confpasswordVisible,
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
                          _confpasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _confpasswordVisible = !_confpasswordVisible;
                          });
                        },
                      ),
                      labelText: 'new Password',
                      hintText: 'Enter your new password!',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MainButton(
                    text: "Update",
                    hasCircularBorder: true,
                    onTap: () async {
                      if (_globalKey.currentState!.validate()) {
                        _globalKey.currentState!.save();

                        try {
                          db.updatePass(
                              emailController.text,
                              _passwordController.text,
                              _newpasswordController.text);
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
