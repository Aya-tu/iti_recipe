import 'package:equatable/equatable.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';


abstract class SavedRecipeState extends Equatable {
  const SavedRecipeState();

  @override
  List<Object> get props => [];
}

class SavedRecipeLoading extends SavedRecipeState {}

class SavedRecipeLoaded extends SavedRecipeState {
  final List<Recipe> recipes;

  const SavedRecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];

  get savedRecipes => null;
}

class SavedRecipeError extends SavedRecipeState {
  final String message;

  const SavedRecipeError(this.message);

  @override
  List<Object> get props => [message];
}