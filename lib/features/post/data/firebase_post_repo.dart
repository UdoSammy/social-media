import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/domain/repo/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // store the posts in a collectiion called posts
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all post with most recent post on top
      final postsSnapshot =
          await postCollection.orderBy('timeStamp', descending: true).get();

      // convert each firestore document from json to lists of post
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      // get post by user id
      final postsSnapshot =
          await postCollection.where('userId', isEqualTo: userId).get();

      // convert firestore documents from json to list
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

          return userPosts;
    } catch (e) {
      throw Exception('Error fetching user posts: $e');
    }
  }
}
