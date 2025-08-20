// saved_recipe_event.dart
import 'package:equatable/equatable.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';




abstract class SavedRecipeEvent extends Equatable {
  const SavedRecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedRecipes extends SavedRecipeEvent {}

class SaveRecipe extends SavedRecipeEvent {
  final Recipe recipe;

  const SaveRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RemoveSavedRecipe extends SavedRecipeEvent {
  final String recipeId;

  const RemoveSavedRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}