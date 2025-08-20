part of 'recipe_bloc.dart';

// Status classes
abstract class RecipeStatus extends Equatable  {
  const RecipeStatus();
  
}

class InitialStatus extends RecipeStatus {
  const InitialStatus();

  @override
  List<Object> get props => [];
}

class LoadingStatus extends RecipeStatus {
  const LoadingStatus();

  @override
  List<Object> get props => [];
}

class SuccessStatus extends RecipeStatus {
  const SuccessStatus();

  @override
  List<Object> get props => [];
}

class FailureStatus extends RecipeStatus {
  final String message;
  const FailureStatus(this.message);

  @override
  List<Object> get props => [message];
}

// State class
class RecipeState extends Equatable {
  final RecipeStatus status;
  final List<Recipe> recipes;
  final String? error;

  const RecipeState({
    this.status = const InitialStatus(),
    this.recipes = const [],
    this.error,
  });

  RecipeState copyWith({
    RecipeStatus? status,
    List<Recipe>? recipes,
    String? error,
  }) {
    return RecipeState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, recipes, error];

  get message => null;
}