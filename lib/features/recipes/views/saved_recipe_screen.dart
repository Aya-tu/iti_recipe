// saved_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_bloc.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_state.dart';
import 'package:recpie/features/recipes/views/recipe_detail_screen.dart';
import 'package:recpie/features/recipes/widgets/recipe_card.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
      ),
      body: BlocBuilder<SavedRecipeBloc, SavedRecipeState>(
        builder: (context, state) {
          if (state is SavedRecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is SavedRecipeError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          
          if (state is SavedRecipeLoaded) {
            if (state.recipes.isEmpty) {
              return const Center(child: Text('No saved recipes found'));
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return Column(
                  children: [
                    RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    ),
                    // Display saved time if available
                    if (recipe.savedAt != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16, left: 8),
                        child: Text(
                          'Saved on ${recipe.savedAt!.toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          }
          
          return const Center(child: Text('Loading saved recipes...'));
        },
      ),
    );
  }
}