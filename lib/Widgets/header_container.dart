// ignore_for_file: unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speakbright_mobile/Widgets/profile_dialogue.dart';
import 'package:speakbright_mobile/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'waiting_dialog.dart';
import '../Screens/auth/auth_controller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RainbowContainer extends StatefulWidget {
  const RainbowContainer({super.key});

  @override
  _RainbowContainerState createState() => _RainbowContainerState();
}

class _RainbowContainerState extends State<RainbowContainer> {
  late Future<DocumentSnapshot> _userDoc;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _setupTTS();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _userDoc = FirebaseFirestore.instance.collection('users').doc(uid).get();
    } else {
      _userDoc = Future.error('User not found');
    }
  }

  Future<void> _setupTTS() async {
    await flutterTts.setLanguage("en-US");
    await _setDefaultVoice();
  }

  Future<void> _setDefaultVoice() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    String voiceName = connectivityResult != ConnectivityResult.none
        ? "Microsoft Aria Online (Natural) - English (United States)"
        : "Microsoft Zira - English (United States)";

    await flutterTts.setVoice({"name": voiceName, "locale": "en-US"});
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await _setDefaultVoice();
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _userDoc,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          String userName = userData['name'] ?? 'User';
          DateTime userBirthday =
              DateTime.parse(userData['birthday'].toDate().toString());

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8E2DE2), mainpurple],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(500),
                      bottomRight: Radius.circular(500),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.logout,
                                color: Color(0xFF8E2DE2), size: 20),
                            onPressed: () {
                              WaitingDialog.show(context,
                                  future: AuthController.I.logout());
                            },
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Hello,",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.w100,
                                          fontFamily: 'Arial',
                                          letterSpacing: 1.5,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "$userName!",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto',
                                          letterSpacing: 1.5,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierColor: Colors
                                              .transparent, // Transparent barrier color
                                          builder: (BuildContext context) {
                                            return ProfileDialogue(
                                              name: userName,
                                              birthday: userBirthday,
                                              onTap: () async {
                                                _speak(
                                                    "Your name is $userName");
                                              },
                                            );
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        elevation:
                                            WidgetStateProperty.all<double>(0),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                dullpurple),
                                      ),
                                      child: const Text('View Profile',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/dash_bg.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.14,
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/explore.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                )
              ],
            ),
          );
        } else {
          // While waiting for the future to complete
          return const WaitingDialog(); // Or a similar loading indicator
        }
      },
    );
  }
}
