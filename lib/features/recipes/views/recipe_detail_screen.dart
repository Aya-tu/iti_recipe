// recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_bloc.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_event.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_state.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});
  
    void _saveRecipe(BuildContext context) async {
    try {
      context.read<SavedRecipeBloc>().add(SaveRecipe(recipe));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving recipe: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe-${recipe.id}',
              child: Image.network(
                recipe.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              recipe.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                  .map((ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('• $ingredient'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.instructions
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text('${entry.key + 1}. ${entry.value}'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            if (user != null)
               BlocConsumer<SavedRecipeBloc, SavedRecipeState>(
        listener: (context, state) {
          if (state is SavedRecipeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return ElevatedButton.icon(
            onPressed: () => _saveRecipe(context),
            icon: const Icon(Icons.bookmark),
            label: const Text('Save Recipe'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
                  );
                },
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to login screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please sign in to save recipes')),
                  );
                },
                icon: const Icon(Icons.bookmark),
                label: const Text('Sign In to Save Recipe'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}