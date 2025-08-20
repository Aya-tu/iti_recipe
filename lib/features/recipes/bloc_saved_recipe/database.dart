// database.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;
  String? get _email => _auth.currentUser?.email;

  CollectionReference<Map<String, dynamic>> _userSavedCol(String uid) {
    return _firestore.collection('users').doc(uid).collection('savedRecipes');
  }

 
  Future<List<Recipe>> getSavedRecipes() async {
    final uid = _uid;
    if (uid == null) return [];

    final snap = await _userSavedCol(uid).get();
    return snap.docs.map((doc) {
      final data = doc.data();
      final withId = {...data, 'id': data['id'] ?? doc.id};
      return Recipe.fromJson(withId);
    }).toList();
  }

 
  Future<void> saveRecipe(Recipe recipe) async {
    final uid = _uid;
    if (uid == null) return;

    await _userSavedCol(uid).doc(recipe.id.toString()).set({
      ...recipe.toJson(),
      'savedAt': DateTime.now(),
      'userId': uid,
      'userEmail': _email,
    });
  }


  Future<void> removeSavedRecipe(String recipeId) async {
    final uid = _uid;
    if (uid == null) return;

    await _userSavedCol(uid).doc(recipeId).delete();
  }
}
