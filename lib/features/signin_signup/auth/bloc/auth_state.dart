import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
final String? userId;
  final String? userName;
  final String? userEmail;

  Authenticated({this.userId, this.userName, this.userEmail});
}

class Unauthenticated extends AuthState {
  final String? error;

  Unauthenticated({this.error});

  @override
  List<Object?> get props => [error ?? ''];
}
