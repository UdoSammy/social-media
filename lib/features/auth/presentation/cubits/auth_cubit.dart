// Auth cubit

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/domain/repos/auth_repo.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) :super(AuthInitial());

  // check if user is alreeady authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if(user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    }else {
      emit(Unauthenticated());
    }
  }

  // get cureent user
  AppUser? get currentUser => _currentUser;

  // login
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);

      if(user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      }else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register
  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, pw);

      if(user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      }else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());

  }
}