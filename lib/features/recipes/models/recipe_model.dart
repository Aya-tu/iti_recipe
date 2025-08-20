// recipe_model.dart
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
  final String? userId;
  final String? userEmail;
  
  Recipe({
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
    this.userId,
    this.userEmail,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Handle different data types that might come from different sources
    int parseId(dynamic id) {
      if (id is int) return id;
      if (id is String) return int.tryParse(id) ?? 0;
      return 0;
    }
    
    int parseTime(dynamic time) {
      if (time is int) return time;
      if (time is String) return int.tryParse(time) ?? 0;
      return 0;
    }
    
    List<String> parseList(dynamic list) {
      if (list is List<String>) return list;
      if (list is List<dynamic>) {
        return list.map((item) => item.toString()).toList();
      }
      return [];
    }

    return Recipe(
      id: parseId(json['id']),
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? 'Medium',
      description: json['description']?.toString() ?? '',
      ingredients: parseList(json['ingredients']),
      instructions: parseList(json['instructions']),
      prepTimeMinutes: parseTime(json['prepTimeMinutes']),
      cookTimeMinutes: parseTime(json['cookTimeMinutes']),
      tags: parseList(json['tags']),
      savedAt: json['savedAt'] != null 
          ? (json['savedAt'] is Timestamp 
              ? (json['savedAt'] as Timestamp).toDate()
              : DateTime.tryParse(json['savedAt'].toString()))
          : null,
      userId: json['userId']?.toString(),
      userEmail: json['userEmail']?.toString(),
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
      'userId': userId,
      'userEmail': userEmail,
    };
  }
}