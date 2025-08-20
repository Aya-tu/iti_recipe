part of 'my_recipe_bloc.dart';

abstract class MyRecipeState extends Equatable {
  const MyRecipeState();

  @override
  List<Object> get props => [];

  get message => null;
}

class MyRecipeInitial extends MyRecipeState {}

class MyRecipesLoaded extends MyRecipeState {
  final List<Recipe> recipes;
  const MyRecipesLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class MyRecipeLoading {
}

class MyRecipeError {
  MyRecipeError(String string);
}