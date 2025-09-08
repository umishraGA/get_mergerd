import '../../../utils/dio/api_service.dart';
import '../models/post_poll_models.dart';
import '../repository/post_poll_repository.dart';
import '../services/video_post_cache_service.dart';

class PostPollViewModel {

  final PostPollRepository postPollRepository;
  final VideoPostCacheService _videoCacheService = VideoPostCacheService();

  PostPollViewModel(): postPollRepository = PostPollRepository(apiService: ApiService());

  /// Fetch all posts and polls
  Future<PostPollResponse> fetchPostPolls({int pageNo = 1, int pageSize = 10}) async {
    try {
      final response = await postPollRepository.getPostPolls(pageNo: pageNo, pageSize: pageSize);
      
      // Preload video posts if response is successful
      if (response.success == true && response.data?.isNotEmpty == true) {
        _videoCacheService.preloadPostVideos(response.data!);
      }
      
      return response;
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Fetch posts and polls with error handling and validation
  Future<PostPollResponse> fetchPostPollsSafe({int pageNo = 1, int pageSize = 10}) async {
    try {
      final response = await postPollRepository.getPostPolls(pageNo: pageNo, pageSize: pageSize);
      
      print('PostPollViewModel: Response received - success: ${response.success}, statusCode: ${response.statusCode}, dataLength: ${response.data?.length}');
      
      // Handle "No posts found" responses as successful empty results
      if (response.success != true) {
        // Check if this is a "no posts found" response (404 with specific message)
        if (response.statusCode == 404 && 
            response.message != null && 
            response.message!.toLowerCase().contains('no approved posts')) {
          print('PostPollViewModel: No posts found - treating as empty success response');
          // Convert to successful empty response
          return PostPollResponse(
            statusCode: 200,
            success: true,
            message: response.message ?? 'No posts available',
            data: [], // Empty list
          );
        }
        
        print('PostPollViewModel: API returned unsuccessful response: ${response.message}');
        throw Exception('API returned unsuccessful response: ${response.message}');
      }
      
      // Allow null status codes since API sometimes returns null instead of 200
      // Also allow 404 for "no posts found" scenarios
      if (response.statusCode != null && 
          response.statusCode != 200 && 
          response.statusCode != 404) {
        print('PostPollViewModel: API returned non-200/404 status code: ${response.statusCode}');
        throw Exception('API returned status code: ${response.statusCode}');
      }
      
      print('PostPollViewModel: Validation passed, returning ${response.data?.length ?? 0} posts');
      
      // Preload video posts if data is available
      if (response.data?.isNotEmpty == true) {
        _videoCacheService.preloadPostVideos(response.data!);
      }
      
      return response;
    } catch (e) {
      print('PostPollViewModel: Error occurred: $e');
      throw Exception('Service error: $e');
    }
  }

  Future<PostPollResponse> fetchPostPollsForFollowingSafe({int pageNo = 1, int pageSize = 10}) async {
    try {
      final response = await postPollRepository.getFollowingPosts(pageNo: pageNo, pageSize: pageSize);

      // Handle "No posts found" responses as successful empty results
      if (response.success != true) {
        // Check if this is a "no posts found" response (404 with specific message)
        if (response.statusCode == 404 && 
            response.message != null && 
            (response.message!.toLowerCase().contains('no approved posts') ||
             response.message!.toLowerCase().contains('no following posts'))) {
          print('PostPollViewModel: No following posts found - treating as empty success response');
          // Convert to successful empty response
          return PostPollResponse(
            statusCode: 200,
            success: true,
            message: response.message ?? 'No following posts available',
            data: [], // Empty list
          );
        }
        
        throw Exception('API returned unsuccessful response: ${response.message}');
      }

      // Allow null status codes since API sometimes returns null instead of 200
      // Also allow 404 for "no posts found" scenarios
      if (response.statusCode != null && 
          response.statusCode != 200 && 
          response.statusCode != 404) {
        throw Exception('API returned status code: ${response.statusCode}');
      }

      // Preload video posts for following posts too
      if (response.data?.isNotEmpty == true) {
        _videoCacheService.preloadPostVideos(response.data!);
      }

      return response;
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Fetch posts and polls with custom parameters and pagination
  Future<PostPollResponse> fetchPostPollsWithParams(
    Map<String, dynamic> queryParameters, {
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    try {
      return await postPollRepository.getPostPollsWithParams(
        queryParameters,
        pageNo: pageNo,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Fetch comments for a specific post
  Future<CommentResponse> fetchPostComments(String postId) async {
    try {
      return await postPollRepository.getPostComment(postId);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Add a comment to a post
  Future<AddCommentResponse> addComment(String postId, AddCommentRequest request) async {
    try {
      return await postPollRepository.addPostComment(postId, request);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Update a comment
  Future<PostPollResponse> updateComment(String commentId, String message) async {
    try {
      return await postPollRepository.updateComment(commentId, message);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Delete a comment
  Future<PostPollResponse> deleteComment(String commentId) async {
    try {
      return await postPollRepository.deleteComment(commentId);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Like/Unlike a post
  Future<PostPollResponse> likePost(String postId) async {
    try {
      return await postPollRepository.likePost(postId);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Like/Unlike a poll
  Future<PostPollResponse> likePoll(String pollId) async {
    try {
      return await postPollRepository.likePolls(pollId);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Add reaction to a post
  Future<PostPollResponse> addPostReaction(AddPostReaction reaction) async {
    try {
      return await postPollRepository.addReaction(reaction);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Add reaction to a poll
  Future<PostPollResponse> addPollReaction(String pollId, PollReaction reaction) async {
    try {
      return await postPollRepository.addPollsReaction(pollId, reaction);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Save/unsave a post
  Future<PostPollResponse> savePost(SavePost savePostRequest) async {
    try {
      return await postPollRepository.savePost(savePostRequest);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Get saved posts
  Future<PostPollResponse> getSavePost() async {
    try {
      return await postPollRepository.getSavePost();
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Report a post
  Future<PostPollResponse> reportPost(PostReport report) async {
    try {
      return await postPollRepository.createPostPollsStoryReport(report);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Add or remove vote from a poll
  Future<PostPollResponse> addVote(String pollId, String optionId) async {
    try {
      return await postPollRepository.addVote(pollId, optionId);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

}
