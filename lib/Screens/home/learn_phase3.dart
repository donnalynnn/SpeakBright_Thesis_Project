// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speakbright_mobile/Routing/router.dart';
import 'package:speakbright_mobile/Screens/home/phase_navigation.dart';
import 'package:speakbright_mobile/Widgets/cards/card_grid.dart';
import 'package:speakbright_mobile/Widgets/constants.dart';
import 'package:speakbright_mobile/Widgets/prompt/prompt_button.dart';
import 'package:speakbright_mobile/Widgets/services/firestore_service.dart';
import 'package:speakbright_mobile/Widgets/services/tts_service.dart';
import 'package:speakbright_mobile/Widgets/waiting_dialog.dart';
import 'package:speakbright_mobile/providers/card_activity_provider.dart';
import 'package:speakbright_mobile/providers/card_provider.dart';
import 'package:dotted_border/dotted_border.dart';

class Learn3 extends ConsumerStatefulWidget {
  const Learn3({super.key});

  static const String route = "/learn3";
  static const String path = "/learn3";
  static const String name = "Learn3";

  @override
  ConsumerState<Learn3> createState() => _Learn3State();
}

class _Learn3State extends ConsumerState<Learn3> {
  final TTSService _ttsService = TTSService();
  final FirestoreService _firestoreService = FirestoreService();

  List<String> sentence = [];
  List<String> categories = [];
  int currentUserPhase = 3;
  int selectedCategory = -1;

  @override
  void initState() {
    super.initState();
    _firestoreService.fetchCategories().then((value) {
      setState(() {
        categories.addAll(value);
        sentence.add("I feel");
      });
    });
  }

  void _clearSentence() {
    setState(() {
      sentence.clear();
      sentence.add("I feel");
    });
  }

  void _addCardTitleToSentence(String title) {
    setState(() {
      if (sentence.length > 1) {
        sentence[sentence.length - 1] = title;
      } else {
        sentence.add(title);
      }
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _sendSentenceAndSpeak() async {
    String sentenceString = sentence.join(' ');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: kLightPruple,
            size: 50.0,
          ),
        );
      },
    );

    try {
      _firestoreService.storeSentence(sentence);
      _ttsService.speak(sentenceString);
      _clearSentence();
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardActivity = ref.watch(cardActivityProvider);
    final cardsAsyncValue = ref.watch(cardsListProviderPhase3);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: phase3Color,
          onPressed: () {
            GlobalRouter.I.router.pop();
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: kwhite,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              PromptButton(phaseCurrent: currentUserPhase),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5, top: 10),
            child: Image.asset(
              'assets/phase/phase3.png',
            ),
          ),
          GestureDetector(
            onTap: () {
              // Check the current bufferSize and toggle its value
              if (cardActivity.bufferSize == 20) {
                cardActivity.setbufferSize(10);
              } else if (cardActivity.bufferSize == 10) {
                cardActivity.setbufferSize(20);
              }
            },
            child: Container(
              height: 30,
              width: 150,
              decoration: BoxDecoration(
                color: cardActivity.bufferSize == 20
                    ? phase3Color.withOpacity(0.5)
                    : const Color.fromARGB(204, 83, 105, 160),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "${cardActivity.trial} of ${cardActivity.bufferSize} trials",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DottedBorder(
                    color: dullpurple,
                    strokeWidth: 1,
                    dashPattern: const [6, 7],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * .8,
                      decoration: BoxDecoration(
                        color: kwhite,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: sentence.isEmpty
                          ? const Center(
                              child: Text(
                                "TAP CARDS TO CREATE A SENTENCE",
                                style: TextStyle(
                                    color: kLightPruple,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sentence.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: kwhite,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sentence[index],
                                      style: const TextStyle(
                                          color: dullpurple, fontSize: 24.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: mainpurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: _sendSentenceAndSpeak,
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: mainpurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: _clearSentence,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: cardsAsyncValue.when(
              data: (cards) {
                print('Cards fetched successfully: ${cards.length}');
                return CardGrid(
                  phase: 3,
                  cards: cards,
                  onCardTap:
                      (String cardTitle, String category, String cardId) {
                    cardActivity.setCardId(cardId);
                    _addCardTitleToSentence(cardTitle);
                    _ttsService.speak(cardTitle);
                    print('title: $cardTitle, cat: $category');
                  },
                  onCardDelete: (String cardId) {
                    ref.read(cardProvider.notifier).deleteCard(cardId, '0');
                  },
                  selectedCategory: selectedCategory == -1
                      ? "All"
                      : categories[selectedCategory],
                );
              },
              loading: () {
                print('Loading cards...');
                return const Center(child: WaitingDialog());
              },
              error: (error, stack) {
                print('Error fetching cards: $error');
                return Center(child: Text('Error: $error'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
