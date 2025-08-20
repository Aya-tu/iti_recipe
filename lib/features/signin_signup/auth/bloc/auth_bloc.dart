import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

   void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final user = authRepository.currentUser;
      if (user != null) {
        // Add user data to Authenticated state
        emit(Authenticated(
          userId: user.uid,
          userName: user.displayName,
          userEmail: user.email,
        ));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp(
          event.name, event.email, event.password);
      
      // Get updated user after sign-up
      final user = authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(
          userId: user.uid,
          userName: user.displayName,
          userEmail: user.email,
        ));
      } else {
        emit(Unauthenticated(error: "User creation failed"));
      }
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signIn(event.email, event.password);
      
      // Get user after sign-in
      final user = authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(
          userId: user.uid,
          userName: user.displayName,
          userEmail: user.email,
        ));
      } else {
        emit(Unauthenticated(error: "Sign-in failed"));
      }
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
    emit(Unauthenticated());
  }
}