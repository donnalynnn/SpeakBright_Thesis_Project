import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  Future<void> storeSentence(List<String> sentence) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    CollectionReference sentences =
        FirebaseFirestore.instance.collection('sentences');

    Map<String, dynamic> sentenceData = {
      'sentence': sentence.join(' '),
      'userID': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await sentences.add(sentenceData);
  }

  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      return querySnapshot.docs
          .map((doc) => doc['category'] as String)
          .toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<void> storeTappedCards(String cardTitle, String category) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('card_basket');
    final DocumentReference userDoc = usersCollection.doc(user.uid);

    await userDoc.set({
      'userID': user.uid,
    }, SetOptions(merge: true));

    final CollectionReference sessionsCollection =
        userDoc.collection('sessions');

    // find lastest session
    final DateTime now = DateTime.now();
    final QuerySnapshot querySnapshot = await sessionsCollection
        .where('sessionTime',
            isGreaterThan:
                Timestamp.fromDate(now.subtract(const Duration(minutes: 5))))
        .orderBy('sessionTime', descending: true)
        .limit(1)
        .get();

    DocumentReference sessionDoc;

    if (querySnapshot.docs.isNotEmpty) {
      sessionDoc = querySnapshot.docs.first.reference;
    } else {
      final Map<String, dynamic> newSessionData = {
        'sessionID': sessionsCollection.doc().id,
        'sessionTime': Timestamp.fromDate(now),
      };
      sessionDoc = await sessionsCollection.add(newSessionData);
    }

    await sessionDoc.collection('cardsTapped').add({
      'cardTitle': cardTitle,
      'category': category,
      'timeTapped': Timestamp.fromDate(now),
    });
  }

  void tapCountIncrement(String cardId) {
    FirebaseFirestore.instance.collection('cards').doc(cardId).update({
      'tapCount': FieldValue.increment(1),
    });
  }
}