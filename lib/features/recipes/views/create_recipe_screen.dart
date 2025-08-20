import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:recpie/features/recipes/bloc_my_recipe/my_recipe_bloc.dart';
import 'package:recpie/features/recipes/bloc_recipe/recipe_bloc.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Recipe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recipe Ditails'),
                        const SizedBox(height: 8),
                        const Text('Basic information about your recipe'),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "e.g., Spaghetti Carbonar",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter a title"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Text('Description'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText:
                                "Describe your recipe in a few sentences...",
                          ),
                          maxLines: 3,
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter a description"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ingredientsController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Ingredients (comma separated)",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter at least one ingredient"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        const Text('Imgae URL'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "https://example.com/image.jpg",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter an image URL"
                              : null,
                        ),
                        TextFormField(
                          controller: _prepTimeController,
                          decoration: const InputDecoration(
                            labelText: "Prep Time (minutes)",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter prep time"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cookTimeController,
                          decoration: const InputDecoration(
                            labelText: "Cook Time (minutes)",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter cook time"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _difficultyController.text.isNotEmpty
                              ? _difficultyController.text
                              : 'Medium',
                          items: ['Easy', 'Medium', 'Hard']
                              .map((level) => DropdownMenuItem(
                                    value: level,
                                    child: Text(level),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _difficultyController.text = value;
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: "Difficulty",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _instructionsController,
                          decoration: const InputDecoration(
                            labelText: "Instructions (one per line)",
                          ),
                          maxLines: 5,
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter instructions"
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newRecipe = Recipe(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: _titleController.text.trim(),
                      image: _imageUrlController.text.trim(),
                      difficulty: _difficultyController.text,
                      description: _descriptionController.text.trim(),
                      ingredients: _ingredientsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList(),
                      instructions: [], // Add if you have instructions
                      prepTimeMinutes:
                          int.tryParse(_prepTimeController.text) ?? 0,
                      cookTimeMinutes:
                          int.tryParse(_cookTimeController.text) ?? 0,
                      tags: [],
                    );

                    // Add to MyRecipeBloc instead of RecipeBloc
                    context.read<MyRecipeBloc>().add(AddMyRecipe(newRecipe));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Recipe"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddRecipe extends RecipeEvent {
  final String title;
  final String description;
  final List<String> ingredients;
  final String imageUrl;

  const AddRecipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [title, description, ingredients, imageUrl];
}
