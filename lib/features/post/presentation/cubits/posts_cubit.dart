import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/post/domain/repo/post_repo.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/features/storage/storage_repo.dart';

class PostsCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostsCubit({required this.postRepo, required this.storageRepo})
      : super(PostsInitial());

  // create post

  
}
