// saved_recipe_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recpie/database.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_event.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_state.dart';

// saved_recipe_bloc.dart
// ... imports

class SavedRecipeBloc extends Bloc<SavedRecipeEvent, SavedRecipeState> {
  final Database _database = Database();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  SavedRecipeBloc() : super(SavedRecipeLoading()) {
    on<LoadSavedRecipes>(_onLoadSavedRecipes);
    on<SaveRecipe>(_onSaveRecipe);
    on<RemoveSavedRecipe>(_onRemoveSavedRecipe);

    // Load saved recipes when bloc is created
    add(LoadSavedRecipes());

    // Listen to auth state changes
    _authSubscription = _auth.authStateChanges().listen((user) {
      add(LoadSavedRecipes());
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadSavedRecipes(
    LoadSavedRecipes event,
    Emitter<SavedRecipeState> emit,
  ) async {
    try {
      final recipes = await _database.getSavedRecipes();
      emit(SavedRecipeLoaded(recipes));
    } catch (e) {
      emit(SavedRecipeError('Failed to load saved recipes: ${e.toString()}'));
    }
  }

  Future<void> _onSaveRecipe(
    SaveRecipe event,
    Emitter<SavedRecipeState> emit,
  ) async {
    try {
      await _database.saveRecipe(event.recipe);
      // Reload saved recipes after saving
      add(LoadSavedRecipes());
    } catch (e) {
      emit(SavedRecipeError('Failed to save recipe: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveSavedRecipe(
    RemoveSavedRecipe event,
    Emitter<SavedRecipeState> emit,
  ) async {
    try {
      await _database.removeSavedRecipe(event.recipeId);
      // Reload saved recipes after removal
      add(LoadSavedRecipes());
    } catch (e) {
      emit(SavedRecipeError('Failed to remove recipe: ${e.toString()}'));
    }
  }
}
