import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final int id;
  final String name;
  final String image;
  final String difficulty;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> tags;
  final DateTime? savedAt;
  
  Recipe( {
    required this.id,
    required this.name,
    required this.image,
    required this.difficulty,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.tags,
    this.savedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      difficulty: json['difficulty'] ?? 'Medium',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      savedAt: json['savedAt'] != null 
          ? (json['savedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'difficulty': difficulty,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'tags': tags,
    };
  }
  
}
