import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nfc_id_reader/providers/userprovider.dart';
import 'package:nfc_id_reader/services/database.dart';
import 'package:nfc_id_reader/widgets/mainButton.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  UserProvider myprovider;
  EditProfile({super.key, required this.myprovider});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final db = Database();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
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
                    controller: nameController,
                    focusNode: nameFocusNode,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(emailFocusNode),
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter your Name!';
                      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(val)) {
                        return 'Invalid name. Only letters and spaces are allowed.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        FontAwesomeIcons.user,
                        size: 25,
                      ),
                      labelText: 'Name',
                      hintText: widget.myprovider.user!.name,
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
                      prefixIcon: Icon(
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
                    validator: (val) => val!.isEmpty
                        ? 'Please enter your current password!'
                        : null,
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
                      labelText: 'Current Password',
                      hintText: 'Enter your current password!',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      labelStyle: TextStyle(
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
                        final _auth = FirebaseAuth.instance;
                        final _firestore = FirebaseFirestore.instance;

                        try {
                          Future<void> updateinfo(
                            String name,
                            String email,
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
                              // Save the user's information on Firestore
                              await _firestore
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                'name': name,
                              });
                              print('Name updated successfully');
                              Navigator.pop(context);
                            } catch (e) {
                              print('Error updating Name: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          }

                          updateinfo(
                            nameController.text,
                            emailController.text,
                            _passwordController.text,
                          );
                          // db
                          //     .updateinfo(
                          //       nameController.text,
                          //       emailController.text,
                          //       _passwordController.text,
                          //     )
                          // .onError((error, stackTrace) =>
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content: Text(
                          //           error.toString(),
                          //         ),
                          //       ),
                          //     ));

                          // Navigator.pop(context);
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
