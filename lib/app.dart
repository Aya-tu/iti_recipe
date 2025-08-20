import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_bloc.dart';
import 'package:recpie/features/recipes/bloc_saved_recipe/saved_recipe_event.dart';
import 'package:recpie/features/recipes/views/saved_recipe_screen.dart';
import 'package:recpie/features/recipes/widgets/main_navigation.dart';
import 'package:recpie/features/signin_signup/auth/bloc/auth_event.dart';
import 'package:recpie/features/signin_signup/auth/bloc/auth_state.dart';
import 'features/signin_signup/auth/bloc/auth_bloc.dart';
import 'features/signin_signup/auth/repository/auth_repository.dart';
import 'features/recipes/bloc_recipe/recipe_bloc.dart';
import 'features/signin_signup/view/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AppStarted()),
        ),
        BlocProvider<SavedRecipeBloc>(
        create: (context) => SavedRecipeBloc(),
      ),
        BlocProvider(
          create: (context) => RecipeBloc(),
        ),
        BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc()..add(LoadRecipes()),
    ),
    BlocProvider<SavedRecipeBloc>(
      create: (context) => SavedRecipeBloc()..add(LoadSavedRecipes()),
    ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RecipeBook',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
        ),
        home: const AuthWrapper(
          
        ),
        routes: {
          '/saved': (context) => const SavedRecipesScreen(),
        }

      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

   @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Load recipes when authenticated
          context.read<RecipeBloc>().add(LoadRecipes());
          return const MainNavigation(); // <-- new widget with bottom nav
        } 
        
        else {
          return const LoginPage();
        }
      },
    );
  }
}