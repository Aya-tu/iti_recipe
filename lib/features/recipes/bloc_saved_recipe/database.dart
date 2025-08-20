// database.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';

class Database {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get the current user's saved recipes collection
  CollectionReference get _savedRecipesCollection {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    print("Using uid: ${user.uid}");
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_recipes');
  }

  /// Save a recipe to the current user's saved recipes
  Future<void> saveRecipe(Recipe recipe) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated. Please sign in to save recipes.');
      }
      
      await _savedRecipesCollection.doc(recipe.id.toString()).set({
        ...recipe.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userEmail': user.email,
      });
    } catch (e) {
      print('Error saving recipe: $e');
      rethrow;
    }
  }

  /// Get all saved recipes for the current user ordered by saved time
  Future<List<Recipe>> getSavedRecipes() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return []; // Return empty list if user is not authenticated
      }
      
      final snapshot = await _savedRecipesCollection
          .orderBy('savedAt', descending: true)
          .get();
          
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Recipe.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting saved recipes: $e');
      rethrow;
    }
  }

  /// Listen for real-time updates to the current user's saved recipes
  Stream<List<Recipe>> listenToSavedRecipes() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    
    return _savedRecipesCollection
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Recipe.fromJson(data);
            })
            .toList())
        .handleError((error) {
          print('Error listening to saved recipes: $error');
          return [];
        });
  }

  /// Remove a recipe from the current user's saved recipes
  Future<void> removeSavedRecipe(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      await _savedRecipesCollection.doc(recipeId).delete();
    } catch (e) {
      print('Error removing saved recipe: $e');
      rethrow;
    }
  }

  /// Check if a recipe is saved by the current user
  Future<bool> isRecipeSaved(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }
      
      final doc = await _savedRecipesCollection.doc(recipeId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if recipe is saved: $e');
      return false;
    }
  }
}