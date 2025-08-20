part of 'my_recipe_bloc.dart';

abstract class MyRecipeEvent extends Equatable {
  const MyRecipeEvent();

  @override
  List<Object> get props => [];
}

class AddMyRecipe extends MyRecipeEvent {
  final Recipe recipe;
  const AddMyRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}