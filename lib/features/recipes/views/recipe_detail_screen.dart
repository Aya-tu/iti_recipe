import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_bloc.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_event.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_state.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';
import 'package:recpie/features/signin_signup/view/signup_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isSaved = false;
  bool _isCheckingSavedStatus = true;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  void _checkIfSaved() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isSaved = false;
        _isCheckingSavedStatus = false;
      });
      return;
    }

    final savedRecipesBloc = BlocProvider.of<SavedRecipeBloc>(context);


    if (savedRecipesBloc.state is SavedRecipeLoaded) {
      final state = savedRecipesBloc.state as SavedRecipeLoaded;
      setState(() {
        _isSaved = state.recipes.any((recipe) => recipe.id == widget.recipe.id);
        _isCheckingSavedStatus = false;
      });
    } else {

      if (savedRecipesBloc.state is! SavedRecipeLoading) {
        savedRecipesBloc.add(LoadSavedRecipes());
      }
      savedRecipesBloc.stream.listen((state) {
        if (state is SavedRecipeLoaded) {
          if (mounted) {
            setState(() {
              _isSaved =
                  state.recipes.any((recipe) => recipe.id == widget.recipe.id);
              _isCheckingSavedStatus = false;
            });
          }
        } else if (state is SavedRecipeError) {
          if (mounted) {
            setState(() {
              _isCheckingSavedStatus = false;
            });
          }
        }
      });
    }
  }

  void _toggleSaveRecipe(BuildContext context) {
    final savedRecipesBloc = BlocProvider.of<SavedRecipeBloc>(context);

    if (_isSaved) {
      savedRecipesBloc.add(RemoveSavedRecipe(widget.recipe.id.toString()));
    } else {
      savedRecipesBloc.add(SaveRecipe(widget.recipe));
    }

    setState(() {
      _isSaved = !_isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe-${widget.recipe.id}',
              child: Image.network(
                widget.recipe.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.recipe.description,
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
              children: widget.recipe.ingredients
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
              children: widget.recipe.instructions
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
              _isCheckingSavedStatus
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: () => _toggleSaveRecipe(context),
                      icon: Icon(
                          _isSaved ? Icons.bookmark_remove : Icons.bookmark),
                      label: Text(_isSaved ? 'Remove Saved' : 'Save Recipe'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSaved
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    )
            else
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
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
