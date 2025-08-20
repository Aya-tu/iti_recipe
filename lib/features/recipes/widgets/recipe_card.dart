import 'package:flutter/material.dart';
import 'package:recpie/features/recipes/models/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image
              if (recipe.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    recipe.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // Recipe title
              Text(
                recipe.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              const SizedBox(height: 8),
              
              // Difficulty and time
              Row(
                children: [
                  Chip(
                    label: Text(recipe.difficulty),
                    backgroundColor: _getDifficultyColor(recipe.difficulty),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text('${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min'),
                    backgroundColor: Colors.blue[50],
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                recipe.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: 12),
              
              // Tags
              Wrap(
                spacing: 8,
                children: recipe.tags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Colors.grey[200],
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green[100]!;
      case 'medium':
        return Colors.orange[100]!;
      case 'hard':
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}