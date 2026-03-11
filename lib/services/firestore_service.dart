import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gadget_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -- Users --
  Future<void> createUserProfile(UserModel user) async {
    await _db
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  // -- Gadgets --
  Stream<List<GadgetModel>> getGadgets() {
    return _db.collection('gadgets').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GadgetModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<GadgetModel>> getGadgetsByCategory(String category) {
    return _db
        .collection('gadgets')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GadgetModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<List<GadgetModel>> getTrendingGadgets() {
    return _db
        .collection('gadgets')
        .where('trending', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GadgetModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // -- Favorites (Bookmarks) --
  Future<void> toggleFavorite(
    String uid,
    String gadgetId,
    bool isFavorite,
  ) async {
    final userRef = _db.collection('users').doc(uid);
    if (isFavorite) {
      await userRef.update({
        'favoriteGadgetIds': FieldValue.arrayUnion([gadgetId]),
      });
    } else {
      await userRef.update({
        'favoriteGadgetIds': FieldValue.arrayRemove([gadgetId]),
      });
    }
  }
}
