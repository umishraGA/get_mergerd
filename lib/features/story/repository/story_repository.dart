import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constant/endpoints.dart';
import '../../../utils/dio/api_service.dart';
import '../../../utils/dio/auth_helper.dart';
import '../../../utils/locationUtils/LocationUtils.dart';
import '../../posts/models/post_poll_models.dart';
import '../models/story_response_models.dart';

/// Repository for handling story-related API calls
class StoryRepository {
  final ApiService _apiService;

  /// Creates a [StoryRepository] with the provided [ApiService]
  StoryRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get bearer token from SharedPreferences
  Future<String?> _getBearerToken() async {
    try {
      final token = await AuthHelper.getAuthToken;
      // await SharedPreferences.getInstance();
      // return prefs.getString('auth_token');
      // Using hardcoded token for now, same as PostPollRepository
      // const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6Ijk2NTEzNDI4ODciLCJfaWQiOiI2ODhkZDM5MGM3NDAxMGQ1MzUwYTNhZDUiLCJpYXQiOjE3NTQxMjUyMDAsImV4cCI6MTc1NjcxNzIwMH0.adE1S2WxS_kqaWExyxuSwjnosmLqx7J68NvGUIvjGZU";
      return "Bearer $token";
    } catch (e) {
      return null;
    }
  }

  /// Fetch stories from API
  Future<StoryResponse> getStories({int pageNo = 1, int pageSize = 10}) async {
    try {
      // Verify token exists before making request
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      var coordinates = await LocationUtils.getUserCoordinates();
      var latitude = coordinates[0];
      var longitude = coordinates[1];
      var stories = Endpoints.getStory+"/$latitude/$longitude";
      return await _apiService.get<StoryResponse>(
        stories,
        // queryParameters: {
        //   'pageNo': pageNo,
        //   'pageSize': pageSize,
        // },
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            StoryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Fetch stories with custom parameters
  Future<StoryResponse> getStoriesWithParams(
    Map<String, dynamic> queryParameters, {
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final params = {
        ...queryParameters,
        'pageNo': pageNo,
        'pageSize': pageSize,
      };

      return await _apiService.get<StoryResponse>(
        Endpoints.getStory,
        queryParameters: params,
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            StoryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Fetch user's own stories
  Future<StoryResponse> getUserStories(
    String userId, {
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<StoryResponse>(
        Endpoints.getStory,
        queryParameters: {
          'userId': userId,
          'pageNo': pageNo,
          'pageSize': pageSize,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            StoryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Like a story
  Future<StoryResponse> likeStory(String storyId) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.put<StoryResponse>(
        '${Endpoints.likeStory}/$storyId',
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            StoryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Add reaction to a story
  Future<StoryResponse> addStoryReaction(AddPostReaction reaction) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<StoryResponse>(
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

            return StoryResponse.fromJson(safeData);
          },
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

}