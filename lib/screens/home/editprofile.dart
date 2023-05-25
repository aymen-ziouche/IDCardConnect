import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final db = Database();
    final emailController = TextEditingController();
    final newemailController = TextEditingController();
    final nameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _newpasswordController = TextEditingController();
    final emailFocusNode = FocusNode();
    final newemailFocusNode = FocusNode();
    final nameFocusNode = FocusNode();
    final _passwordFocusNode = FocusNode();
    final _newpasswordFocusNode = FocusNode();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter your name!' : null,
                  decoration: InputDecoration(
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
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter your email!' : null,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: widget.myprovider.user!.email,
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
                  controller: newemailController,
                  focusNode: newemailFocusNode,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter your New email!' : null,
                  decoration: InputDecoration(
                    labelText: 'New Email',
                    hintText: widget.myprovider.user!.email,
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
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
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
                const SizedBox(height: 34.0),
                TextFormField(
                  controller: _newpasswordController,
                  focusNode: _newpasswordFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter your new password!' : null,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'new Password',
                    hintText: 'Enter your new password!',
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
                    db.updateinfo(
                      nameController.text,
                      emailController.text,
                      newemailController.text,
                      _passwordController.text,
                      _newpasswordController.text,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
