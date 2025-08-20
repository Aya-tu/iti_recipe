import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:recpie/features/recipes/models/recipe_model.dart';

part 'my_recipe_event.dart';
part 'my_recipe_state.dart';

class MyRecipeBloc extends Bloc<MyRecipeEvent, MyRecipeState> {
  MyRecipeBloc() : super(MyRecipeInitial()) {
    on<AddMyRecipe>(_onAddRecipe);
  }

  void _onAddRecipe(AddMyRecipe event, Emitter<MyRecipeState> emit) {
    if (state is MyRecipesLoaded) {
      final currentState = state as MyRecipesLoaded;
      final newRecipes = List<Recipe>.from(currentState.recipes)
        ..add(event.recipe);
      emit(MyRecipesLoaded(newRecipes));
    } else {
      emit(MyRecipesLoaded([event.recipe]));
    }
  }
}