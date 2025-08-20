import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpRequested(this.name, this.email, this.password);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignOutRequested extends AuthEvent {}