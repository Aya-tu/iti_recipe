import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:recpie/features/recipes/models/recipe_model.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(const RecipeState()) {
    on<LoadRecipes>(_onLoadRecipes);
  }

  Future<void> _onLoadRecipes(
    LoadRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(state.copyWith(status: const LoadingStatus()));
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/recipes'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipes = (data['recipes'] as List)
            .map((json) => Recipe.fromJson(json))
            .toList();
        emit(state.copyWith(
          status: const SuccessStatus(),
          recipes: recipes,
        ));
      } else {
        emit(state.copyWith(
          status:
              FailureStatus('Failed to load recipes: ${response.statusCode}'),
          error: 'Failed to load recipes: ${response.statusCode}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FailureStatus(e.toString()),
        error: e.toString(),
      ));
    }
  }
}
