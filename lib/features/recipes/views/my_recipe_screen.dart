import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recpie/features/recipes/bloc_my_recipe/my_recipe_bloc.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';
import 'create_recipe_screen.dart';

class MyRecipeScreen extends StatelessWidget {
  const MyRecipeScreen({super.key});

  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyRecipeBloc, MyRecipeState>(
      builder: (context, state) {
        if (state is MyRecipeInitial) {
          return _buildEmptyState(context);
        } else if (state is MyRecipesLoaded) {
          return _buildRecipeList(state.recipes);
        }
        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No recipes yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateRecipeScreen(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Create Your First Recipe'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateRecipeScreen(),
          ),
        ),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context!,
              MaterialPageRoute(
                builder: (context) => const CreateRecipeScreen(),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.restaurant, size: 40),
              title: Text(recipe.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    recipe.description.length > 100
                        ? '${recipe.description.substring(0, 100)}...'
                        : recipe.description,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                            '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min'),
                        backgroundColor: Colors.amber[100],
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(recipe.difficulty),
                        backgroundColor: Colors.blue[100],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context!,
          MaterialPageRoute(
            builder: (context) => const CreateRecipeScreen(),
          ),
        ),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
