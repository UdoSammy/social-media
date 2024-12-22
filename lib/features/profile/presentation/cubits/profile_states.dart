// profile states


import 'package:socialapp/features/profile/domain/entities/profile_user.dart';

abstract class ProfileStates {}


// initial
class Profileinitial extends ProfileStates {}

// loading...
class ProfileLoading extends ProfileStates {}

// loaded
class PorfileLoaded extends ProfileStates {
  final ProfileUser profileUser;
  PorfileLoaded(this.profileUser);
}

class ProfileError extends ProfileStates {
  final String message;

  ProfileError(this.message);
}