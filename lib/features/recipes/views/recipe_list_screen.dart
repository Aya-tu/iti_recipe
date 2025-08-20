import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recpie/features/recipes/bloc_recipe/recipe_bloc.dart';
import 'package:recpie/features/recipes/views/profile_screen.dart';
import 'package:recpie/features/recipes/views/recipe_detail_screen.dart';
import 'package:recpie/features/recipes/widgets/recipe_card.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.green,
          expandedHeight: 150,
          pinned: true,
          stretch: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: const Text(
              'RecipeBook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 44, 44, 44),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            background: Image.network(
              'https://images.unsplash.com/photo-1490818387583-1baba5e638af?q=80&w=1932&auto=format&fit=crop',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.multiply,
            ),
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search recipes...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),

        // Label
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Showing recipes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),

        // Recipe list
        BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state.status is LoadingStatus) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state.status is FailureStatus) {
              return SliverFillRemaining(
                child: Center(child: Text('Error: ${state.error}')),
              );
            }

            final filteredRecipes = state.recipes.where((recipe) {
              return recipe.name.toLowerCase().contains(_searchQuery) ||
                  recipe.description.toLowerCase().contains(_searchQuery);
            }).toList();

            if (filteredRecipes.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text('No recipes found')),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final recipe = filteredRecipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  );
                },
                childCount: filteredRecipes.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
