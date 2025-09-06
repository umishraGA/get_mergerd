import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constant/endpoints.dart';
import '../../../utils/dio/api_service.dart';
import '../../../utils/dio/auth_helper.dart';
import '../../../utils/locationUtils/LocationUtils.dart';
import '../models/post_poll_models.dart';
import '../../../utils/dio/api_service.dart';



class PostPollRepository {

  final ApiService _apiService;
  PostPollRepository({required ApiService apiService}) // Use required for non-nullable named parameters
      : _apiService = apiService;
  /// Get bearer token from SharedPreferences
  Future<String?> _getBearerToken() async {
    try {
      final token = AuthHelper.getAuthToken;
      print("Token of Auth: $token");
      // await SharedPreferences.getInstance();
      // return prefs.getString('auth_token');
      // const token =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6Ijk2NTEzNDI4ODciLCJfaWQiOiI2ODhkZDM5MGM3NDAxMGQ1MzUwYTNhZDUiLCJpYXQiOjE3NTQxMjUyMDAsImV4cCI6MTc1NjcxNzIwMH0.adE1S2WxS_kqaWExyxuSwjnosmLqx7J68NvGUIvjGZU";
      return "Bearer $token";
    } catch (e) {
      return null;
    }
  }

   getCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('user_latitude') ?? 0.0;
    double longitude = prefs.getDouble('user_longitude') ?? 0.0;
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    return [latitude, longitude];
  }

  /// Fetch posts and polls from the API
  Future<PostPollResponse> getPostPolls({int pageNo = 1, int pageSize = 10}) async {
    try {
      // Verify token exists before making request
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      var coordinates = await LocationUtils.getUserCoordinates();
      // var endPoint =         Endpoints.getPostPolls+"/26.875805/81.020243";
      var endPoint = Endpoints.getPostPolls+"/${coordinates[0]}/${coordinates[1]}";

      print('Coordinates: ${coordinates[0]}, ${coordinates[1]}');
      return await _apiService.get<PostPollResponse>(
        endPoint,
        queryParameters: {
          'page': pageNo,
          'limit': pageSize,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          print('PostPollRepository: Raw API response: $data');
          print('PostPollRepository: Data type: ${data.runtimeType}');
          
          try {
            // Create a safe response structure for getPostPolls operations
            final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
            
            // Handle "no posts found" 404 responses as successful empty responses
            if (safeData['statusCode'] == 404 && 
                safeData['message'] != null &&
                safeData['message'].toString().toLowerCase().contains('no approved posts')) {
              print('PostPollRepository: Converting 404 no posts response to successful empty response');
              safeData['success'] = true;
              safeData['statusCode'] = 200;
              safeData['data'] = [];
            }
            
            // Ensure we have basic response structure
            if (!safeData.containsKey('success')) {
              safeData['success'] = true; // Default to success if not specified
            }
            if (!safeData.containsKey('statusCode')) {
              safeData['statusCode'] = 200; // Default status code
            }
            if (!safeData.containsKey('message')) {
              safeData['message'] = 'Posts fetched successfully'; // Default message
            }
            
            // Handle nested data structure where posts are in data.data
            if (safeData.containsKey('data') && safeData['data'] is Map<String, dynamic>) {
              final Map<String, dynamic> dataMap = safeData['data'] as Map<String, dynamic>;
              print('PostPollRepository: Found nested data structure');
              if (dataMap.containsKey('data') && dataMap['data'] is List) {
                // Extract the posts array from nested data.data structure
                final List postsArray = dataMap['data'] as List;
                print('PostPollRepository: Extracted ${postsArray.length} posts from nested structure');
                safeData['data'] = postsArray;
              } else {
                print('PostPollRepository: No valid data array found in nested structure - setting empty array');
                safeData['data'] = []; // Set empty array instead of null
              }
            } else if (safeData.containsKey('data') && safeData['data'] is! List) {
              print('PostPollRepository: Data field exists but is not a List: ${safeData['data'].runtimeType} - setting empty array');
              safeData['data'] = []; // Set empty array instead of null
            } else if (safeData.containsKey('data') && safeData['data'] is List) {
              print('PostPollRepository: Data is already a List with ${(safeData['data'] as List).length} items');
            } else {
              print('PostPollRepository: No data field found - setting empty array');
              safeData['data'] = []; // Set empty array if no data field
            }
            
            print('PostPollRepository: Final processed data keys: ${safeData.keys.toList()}');
            if (safeData['data'] is List) {
              print('PostPollRepository: Final data array length: ${(safeData['data'] as List).length}');
            }
            
            return PostPollResponse.fromJson(safeData);
          } catch (parseError) {
            print('PostPollRepository: Error parsing response: $parseError');
            // Return a safe empty response if parsing fails
            return const PostPollResponse(
              statusCode: 200,
              success: true,
              message: 'No posts available',
              data: [], // Empty list instead of null
            );
          }
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Fetch posts and polls from the API
  Future<PostPollResponse> getFollowingPosts({int pageNo = 1, int pageSize = 10}) async {
    try {
      // Verify token exists before making request
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<PostPollResponse>(
        Endpoints.getFollowingPost,
        queryParameters: {
          'page': pageNo,
          'limit': pageSize,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          try {
            // Create a safe response structure for getFollowingPosts operations
            final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
            
            // Handle "no posts found" 404 responses as successful empty responses
            if (safeData['statusCode'] == 404 && 
                safeData['message'] != null &&
                (safeData['message'].toString().toLowerCase().contains('no approved posts') ||
                 safeData['message'].toString().toLowerCase().contains('no following posts'))) {
              print('PostPollRepository: Converting 404 no following posts response to successful empty response');
              safeData['success'] = true;
              safeData['statusCode'] = 200;
              safeData['data'] = [];
            }
            
            // Ensure we have basic response structure
            if (!safeData.containsKey('success')) {
              safeData['success'] = true; // Default to success if not specified
            }
            if (!safeData.containsKey('statusCode')) {
              safeData['statusCode'] = 200; // Default status code
            }
            if (!safeData.containsKey('message')) {
              safeData['message'] = 'Following posts fetched successfully'; // Default message
            }
            
            // If data field exists and is not a List, set it to empty array
            if (safeData.containsKey('data') && safeData['data'] is! List) {
              safeData['data'] = []; // Set empty array instead of null
            } else if (!safeData.containsKey('data')) {
              safeData['data'] = []; // Set empty array if no data field
            }
            
            // Handle the different structure in following posts where reactions is a Map
            if (safeData['data'] is List) {
              final List<dynamic> dataList = safeData['data'] as List<dynamic>;
              final List<Map<String, dynamic>> processedData = [];
              
              for (final item in dataList) {
                if (item is Map<String, dynamic>) {
                  final Map<String, dynamic> processedItem = Map.from(item);
                  
                  // Convert reactions Map to List format if needed
                  if (processedItem['reactions'] is Map) {
                    processedItem['reactions'] = [];
                  }
                  
                  processedData.add(processedItem);
                }
              }
              
              safeData['data'] = processedData;
            }
            
            return PostPollResponse.fromJson(safeData);
          } catch (parseError) {
            print('PostPollRepository: Error parsing following posts response: $parseError');
            // Return a safe empty response if parsing fails
            return const PostPollResponse(
              statusCode: 200,
              success: true,
              message: 'No following posts available',
              data: [], // Empty list instead of null
            );
          }
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Fetch posts and polls with query parameters
  Future<PostPollResponse> getPostPollsWithParams(
    Map<String, dynamic> queryParameters, {
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    try {
      // Verify token exists before making request
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      // Merge pagination parameters with custom query parameters
      final mergedParams = {
        'page': pageNo,
        'limit': pageSize,
        ...queryParameters,
      };

      return await _apiService.get<PostPollResponse>(
        Endpoints.getPostPolls,
        queryParameters: mergedParams,
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            PostPollResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get comments for a specific post
  Future<CommentResponse> getPostComment(String postId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<CommentResponse>(
        '${Endpoints.getPostComment}/$postId',
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            CommentResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Add a comment to a post
  Future<AddCommentResponse> addPostComment(String postId, AddCommentRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<AddCommentResponse>(
        '${Endpoints.addPostComment}/$postId',
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            AddCommentResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Update a comment
  Future<PostPollResponse> updateComment(String commentId, String message) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<PostPollResponse>(
        '${Endpoints.updateComment}/$commentId',
        data: {'message': message},
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for update comment operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Delete a comment
  Future<PostPollResponse> deleteComment(String commentId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.delete<PostPollResponse>(
        '${Endpoints.deleteComment}/$commentId',
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for delete comment operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Like a post
  Future<PostPollResponse> likePost(String postId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<PostPollResponse>(
        '${Endpoints.likePost}/$postId',
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Debug logging to see what the API actually returns
          print('Like API Response: $data');
          print('Data type: ${data.runtimeType}');
          if (data is Map<String, dynamic>) {
            print('Data keys: ${data.keys.toList()}');
            print('Data[data] type: ${data['data']?.runtimeType}');
          }
          
          // Create a safe response structure for like operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Like a poll
  Future<PostPollResponse> likePolls(String pollId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<PostPollResponse>(
        '${Endpoints.likePolls}/$pollId',
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for poll like operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Add or remove vote from a poll
  Future<PostPollResponse> addVote(String pollId, String optionId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<PostPollResponse>(
        Endpoints.addVote,
        data: {
          'pollId': pollId,
          'optionId': optionId,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for vote operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // The vote API returns a different structure than the posts list API
          // Set data field to null since vote API doesn't return a posts list
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Add reaction to a post
  Future<PostPollResponse> addReaction(AddPostReaction reaction) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<PostPollResponse>(
        Endpoints.addReaction,
        data: reaction.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for reaction operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Add reaction to a poll
  Future<PostPollResponse> addPollsReaction(String pollId, PollReaction reaction) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<PostPollResponse>(
        '${Endpoints.addPollsReaction}/$pollId',
        data: reaction.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for poll reaction operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Create a report for post/polls/story
  Future<PostPollResponse> createPostPollsStoryReport(PostReport report) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<PostPollResponse>(
        Endpoints.createPostPollsStoryReport,
        data: report.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for report operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Save a post
  Future<PostPollResponse> savePost(SavePost savePostRequest) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<PostPollResponse>(
        Endpoints.savePost,
        data: savePostRequest.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for save post operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get saved posts
  Future<PostPollResponse> getSavePost() async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<PostPollResponse>(
        Endpoints.getSavePost,
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            PostPollResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get stories
  Future<PostPollResponse> getStory() async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<PostPollResponse>(
        Endpoints.getStory,
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            PostPollResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Like a story
  Future<PostPollResponse> likeStory(String storyId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<PostPollResponse>(
        '${Endpoints.likeStory}/$storyId',
        parser: (data) =>
            PostPollResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Follow a user
  Future<PostPollResponse> followUser(String userId,String chooseTypeModel) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<PostPollResponse>(
        Endpoints.followUser,
        data: {
          'following': userId,
          'followingModel': chooseTypeModel,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for follow operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Unfollow a user
  Future<PostPollResponse> unfollowUser(String userId,String chooseTypeModel) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<PostPollResponse>(
        Endpoints.unfollowUser,
        data: {
          'following': userId,
          'followingModel': chooseTypeModel,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) {
          // Create a safe response structure for unfollow operations
          final Map<String, dynamic> safeData = data is Map<String, dynamic> ? Map.from(data) : {};
          
          // If data field exists and is not a List, set it to null
          if (safeData.containsKey('data') && safeData['data'] is! List) {
            safeData['data'] = null;
          }
          
          return PostPollResponse.fromJson(safeData);
        },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
