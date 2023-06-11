import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/services/database.dart';
import 'package:nfc_id_reader/widgets/mainButton.dart';

class EditEmail extends StatefulWidget {
  UserProvider myprovider;
  EditEmail({super.key, required this.myprovider});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final db = Database();
  final emailController = TextEditingController();
  final newemailController = TextEditingController();
  final _passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final newemailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
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
                    "Update your Info: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 68.0),
                  TextFormField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(newemailFocusNode),
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
                    controller: newemailController,
                    focusNode: newemailFocusNode,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your new email!';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(val)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 25,
                      ),
                      labelText: 'New Email',
                      hintText: 'Enter your new email!',
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
                  const SizedBox(
                    height: 50,
                  ),
                  MainButton(
                    text: "Update",
                    hasCircularBorder: true,
                    onTap: () async {
                      if (_globalKey.currentState!.validate()) {
                        _globalKey.currentState!.save();
                        print("My new email" + newemailController.text);
                        final _auth = FirebaseAuth.instance;
                        final _firestore = FirebaseFirestore.instance;

                        try {
                          Future<void> updateEmail(
                            String email,
                            String newemail,
                            String password,
                          ) async {
                            final user = _auth.currentUser;
                            final credential = EmailAuthProvider.credential(
                                email: email, password: password);

                            try {
                              if (emailController.text != user!.email) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("This email is invalid"),
                                  ),
                                );
                              }
                              await user
                                  .reauthenticateWithCredential(credential);

                              await user.updateEmail(newemail);

                              await _firestore
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                'email': newemail,
                              });

                              print('Email updated successfully');
                              print(newemail);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Center(child: Text("Email updated successfully")),
                                ),
                              );
                            } catch (e) {
                              print('Error updating email : $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error updating email : $e'
                                  ),
                                ),
                              );
                            }
                          }

                          updateEmail(
                            emailController.text,
                            newemailController.text,
                            _passwordController.text,
                          );
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
