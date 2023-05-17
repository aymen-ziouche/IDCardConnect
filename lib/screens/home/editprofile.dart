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
    final nameController = TextEditingController();
    final emailFocusNode = FocusNode();
    final nameFocusNode = FocusNode();
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
                const SizedBox(
                  height: 50,
                ),
                MainButton(
                    text: "Update",
                    hasCircularBorder: true,
                    onTap: () async {
                      db.updateinfo(nameController.text, emailController.text);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
