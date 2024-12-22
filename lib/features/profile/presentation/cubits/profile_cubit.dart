import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/profile/domain/repos/profile_repo.dart';
import 'package:socialapp/features/profile/presentation/cubits/profile_states.dart';
import 'package:socialapp/features/storage/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(Profileinitial());

  // fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(PorfileLoaded(user));
      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Update user
  Future<void> updateProfile(
      {required String uid,
      String? newBio,
      Uint8List? imageWebBytes,
      String? mobileImagePath}) async {
    try {
      // fetch user profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError('Failed to fetch user for profile update'));
        return;
      }

      // profile picture update
      String? imageDownloadUrl;
      if (imageWebBytes != null || mobileImagePath != null) {
        // for mobile
        if (mobileImagePath != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(mobileImagePath, uid);
        }
        // for web
        else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError('Failed to upload Image'));
          return;
        }
      }

      // update new profile
      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl
      );

      await profileRepo.updateProfile(updateProfile);

      // refetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile: $e'));
    }
  }
}
