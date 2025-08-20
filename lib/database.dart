import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';

class Database {
  final CollectionReference notesCollection =
  FirebaseFirestore.instance.collection('recipes');
  
  final CollectionReference savedRecipesCollection =
  FirebaseFirestore.instance.collection('saved_recipes');

  /// Create a new note (auto-generated ID)
  Future<void> createNote({
    required String title,
    required String description,
  }) async {
    await notesCollection.add({
      'title': title,
      'description': description,
      'ingredients': String,
      'imgae':Uri(),
      'prep time':int,
      'cook time':int,
      'difficulty':String,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get all notes (one-time fetch)
  Future<List<QueryDocumentSnapshot>> getNotes() async {
    final snapshot = await notesCollection.orderBy('createdAt', descending: true).get();
    return snapshot.docs;
  }

  /// Listen for real-time updates
  Stream<List<QueryDocumentSnapshot>> listenToNotes() {
    return notesCollection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs,
    );
  }

  /// Update a specific note
  Future<void> updateNote({
    required String docId,
    String? title,
    String? description,
  }) async {
    final Map<String, dynamic> updatedData = {};
    if (title != null) updatedData['title'] = title;
    if (description != null) updatedData['description'] = description;

    await notesCollection.doc(docId).update(updatedData);
  }

  /// Delete a note
  Future<void> deleteNote(String docId) async {
    await notesCollection.doc(docId).delete();
  }

   /// Save a recipe to saved recipes
  Future<void> saveRecipe(Recipe recipe) async {
    await savedRecipesCollection.doc(recipe.id.toString()).set(recipe.toJson());
  }

  /// Get all saved recipes (one-time fetch)
  Future<List<Recipe>> getSavedRecipes() async {
    final snapshot = await savedRecipesCollection.get();
    return snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
 /// Listen for real-time updates to saved recipes
  Stream<List<Recipe>> listenToSavedRecipes() {
    return savedRecipesCollection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList(),
    );
  }

  /// Remove a recipe from saved recipes
  Future<void> removeSavedRecipe(String recipeId) async {
    await savedRecipesCollection.doc(recipeId).delete();
  }

  /// Check if a recipe is saved
  Future<bool> isRecipeSaved(String recipeId) async {
    final doc = await savedRecipesCollection.doc(recipeId).get();
    return doc.exists;
  }
}
