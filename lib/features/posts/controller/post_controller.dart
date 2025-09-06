import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/dio/auth_helper.dart';
import '../repository/post_poll_repository.dart';
import '../../../utils/dio/api_service.dart';

class PostModel {
  final String id;
  final String? description;
  final String? question;
  final List<Option>? options;
  final String chooseType;
  final String locution;
  final String locutionkm;
  final String status;
  final double? latCoordinate;
  final double? lngCoordinate;
  final String createdBy;
  final List<ImageModel>? images;
  final String createdAt;
  final String postId;
  final String type;

  PostModel({
    required this.id,
    this.description,
    this.question,
    this.options,
    required this.chooseType,
    required this.locution,
    required this.locutionkm,
    required this.status,
    this.latCoordinate,
    this.lngCoordinate,
    required this.createdBy,
    this.images,
    required this.createdAt,
    required this.postId,
    required this.type,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id']?.toString() ?? '',
      description: json['description']?.toString(),
      question: json['question']?.toString(),
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
              .map((e) => Option.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      chooseType: json['chooseType']?.toString() ?? '',
      locution: json['locution']?.toString() ?? '',
      locutionkm: (json['locutionkm'] ?? json['locationKm'])?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
      latCoordinate:
          _parseDouble(json['latCoordinage'] ?? json['latCoordinate']),
      lngCoordinate:
          _parseDouble(json['langCoordinagee'] ?? json['lngCoordinate']),
      createdBy: json['createdBy']?.toString() ?? '',
      images: json['images'] != null
          ? (json['images'] as List<dynamic>)
              .map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: json['createdAt']?.toString() ?? '',
      postId: json['postId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class Option {
  final String option;
  final int votes;
  final String id;

  Option({required this.option, required this.votes, required this.id});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      option: json['option']?.toString() ?? '',
      votes: _parseInt(json['votes']),
      id: json['_id']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ImageModel {
  final String url;
  final String status;
  final String id;

  ImageModel({required this.url, required this.status, required this.id});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }
}


class PostController extends GetxController {
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var selectedTab = 0.obs;
  var isVoting = false.obs;
  var votingError = ''.obs;
  
  // Track which polls user has voted on
  var votedPolls = <String, String>{}.obs; // postId -> optionId
  
  // Track follow status for users
  var followedUsers = <String, bool>{}.obs; // userId -> isFollowing
  var isFollowingInProgress = false.obs;
  var followError = ''.obs;
  
  // Repository for API calls
  late final PostPollRepository _repository;
  
  // Reaction ID mapping based on API response
  static const Map<String, String> _reactionIdMap = {
    'HAHA': '685b8ee2521c10ea3f72e32d',
    'LOVE': '687a2dd064c066a255fc6b83',
    'ANGRY': '687a2de364c066a255fc6b8e',
    'SAD': '688768f6693697410460acf0',
    'SURPRISE': '6887693e693697410460acfb',
  };

  @override
  void onInit() {
    super.onInit();
    
    // Initialize repository
    final apiService = ApiService();
    _repository = PostPollRepository(apiService: apiService);
    
    _loadVotedPolls();
    _loadFollowedUsers();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      error('');

      final Map<String, dynamic> response = await _getPostsAndPolls();

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        
        // Initialize follow states from API data before creating PostModel objects
        initializeFollowStatesFromPosts(data);
        
        posts.value = data
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        error(response['message']?.toString() ?? 'Failed to fetch posts');
      }
    } catch (e) {
      error('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Initialize follow states from post API response data
  void initializeFollowStatesFromPosts(List<dynamic> postsData) {
    for (final postData in postsData) {
      if (postData is Map<String, dynamic>) {
        final String? createdBy = postData['createdBy']?.toString();
        final bool isFollowing = postData['follow'] == true;
        
        if (createdBy != null && createdBy.isNotEmpty) {
          followedUsers[createdBy] = isFollowing;
          print('Initialized follow state for user $createdBy: $isFollowing');
        }
      }
    }
    
    // Save the updated follow states
    _saveFollowedUsers();
  }

  Future<bool> voteOnPoll(String postId, String optionId) async {
    try {
      isVoting(true);
      votingError('');

      // Call API to submit vote using repository method
      final response = await _repository.addVote(postId, optionId);

      if (response.success == true) {
        // Get previous voted option to update vote counts correctly
        final String? previousOptionId = votedPolls[postId];
        
        // Update local state after successful API call
        _updateLocalPollVoteWithChange(postId, optionId, previousOptionId);
        
        // Track that user has voted on this poll (update or set new vote)
        votedPolls[postId] = optionId;
        
        // Save voted polls to local storage
        await _saveVotedPolls();
        
        return true;
      } else {
        votingError(response.message ?? 'Failed to vote');
        return false;
      }
    } catch (e) {
      votingError('Error voting on poll: $e');
      return false;
    } finally {
      isVoting(false);
    }
  }

  void _updateLocalPollVote(String postId, String optionId) {
    final postIndex = posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = posts[postIndex];
      if (post.options != null) {
        final optionIndex =
            post.options!.indexWhere((option) => option.id == optionId);
        if (optionIndex != -1) {
          final updatedOptions = List<Option>.from(post.options!);
          updatedOptions[optionIndex] = Option(
            option: updatedOptions[optionIndex].option,
            votes: updatedOptions[optionIndex].votes + 1,
            id: updatedOptions[optionIndex].id,
          );

          posts[postIndex] = PostModel(
            id: post.id,
            description: post.description,
            question: post.question,
            options: updatedOptions,
            chooseType: post.chooseType,
            locution: post.locution,
            locutionkm: post.locutionkm,
            status: post.status,
            latCoordinate: post.latCoordinate,
            lngCoordinate: post.lngCoordinate,
            createdBy: post.createdBy,
            images: post.images,
            createdAt: post.createdAt,
            postId: post.postId,
            type: post.type,
          );
        }
      }
    }
  }

  void _updateLocalPollVoteWithChange(String postId, String newOptionId, String? previousOptionId) {
    final postIndex = posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = posts[postIndex];
      if (post.options != null) {
        final updatedOptions = List<Option>.from(post.options!);
        
        // If user had a previous vote, decrement that option's count
        if (previousOptionId != null && previousOptionId.isNotEmpty) {
          final previousOptionIndex = updatedOptions.indexWhere((option) => option.id == previousOptionId);
          if (previousOptionIndex != -1 && updatedOptions[previousOptionIndex].votes > 0) {
            updatedOptions[previousOptionIndex] = Option(
              option: updatedOptions[previousOptionIndex].option,
              votes: updatedOptions[previousOptionIndex].votes - 1,
              id: updatedOptions[previousOptionIndex].id,
            );
          }
        }
        
        // Increment the new option's count
        final newOptionIndex = updatedOptions.indexWhere((option) => option.id == newOptionId);
        if (newOptionIndex != -1) {
          updatedOptions[newOptionIndex] = Option(
            option: updatedOptions[newOptionIndex].option,
            votes: updatedOptions[newOptionIndex].votes + 1,
            id: updatedOptions[newOptionIndex].id,
          );
        }

        posts[postIndex] = PostModel(
          id: post.id,
          description: post.description,
          question: post.question,
          options: updatedOptions,
          chooseType: post.chooseType,
          locution: post.locution,
          locutionkm: post.locutionkm,
          status: post.status,
          latCoordinate: post.latCoordinate,
          lngCoordinate: post.lngCoordinate,
          createdBy: post.createdBy,
          images: post.images,
          createdAt: post.createdAt,
          postId: post.postId,
          type: post.type,
        );
      }
    }
  }

  bool hasUserVoted(String postId) {
    return votedPolls.containsKey(postId);
  }

  String? getUserVotedOption(String postId) {
    return votedPolls[postId];
  }

  Future<void> _saveVotedPolls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final votedPollsJson = json.encode(votedPolls);
      await prefs.setString('voted_polls', votedPollsJson);
    } catch (e) {
      debugPrint('Error saving voted polls: $e');
    }
  }

  Future<void> _loadVotedPolls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final votedPollsJson = prefs.getString('voted_polls');
      if (votedPollsJson != null) {
        final dynamic decodedData = json.decode(votedPollsJson);
        if (decodedData is Map<String, dynamic>) {
          votedPolls.clear();
          decodedData.forEach((key, value) {
            votedPolls[key] = value.toString();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading voted polls: $e');
    }
  }

  /// Maps reaction type string to actual reaction ID for API calls
  static String? getReactionId(String reactionType) {
    return _reactionIdMap[reactionType.toUpperCase()];
  }

  /// Maps legacy reaction types to API reaction type strings
  static String mapReactionTypeToApi(String reactionType) {
    switch (reactionType.toUpperCase()) {
      case 'LIKE':
      case 'HEART':
        return 'LOVE'; // Map like/heart to love
      case 'WOW':
        return 'SURPRISE'; // Map wow to surprise
      default:
        return reactionType.toUpperCase();
    }
  }

  /// Follow/Unfollow a user - relies solely on API response
  Future<Map<String, dynamic>> toggleFollowUser(String userId, String chooseTypeModel, bool currentFollowState) async {
    print('toggleFollowUser called with userId: $userId, currentState: $currentFollowState');
    if (isFollowingInProgress.value) {
      print('Follow operation already in progress');
      return {'success': false, 'newState': currentFollowState, 'message': 'Operation in progress'};
    }

    try {
      isFollowingInProgress(true);
      followError('');

      final String action = currentFollowState ? 'unfollow' : 'follow';
      print('Current follow state: $currentFollowState, action: $action');
      
      // Call appropriate repository method based on current state
      if (currentFollowState) {
        print('Calling unfollow repository method...');
        final response = await _repository.unfollowUser(userId, chooseTypeModel);
        print('Unfollow response: ${response.success}, message: ${response.message}');
        
        if (response.success == true) {
          // Return the new state from API response (should be false after unfollow)
          return {'success': true, 'newState': false, 'message': response.message};
        } else {
          followError(response.message ?? 'Failed to unfollow user');
          return {'success': false, 'newState': currentFollowState, 'message': response.message ?? 'Failed to unfollow user'};
        }
      } else {
        print('Calling follow repository method...');
        final response = await _repository.followUser(userId, chooseTypeModel);
        print('Follow response: ${response.success}, message: ${response.message}');
        
        if (response.success == true) {
          // Return the new state from API response (should be true after follow)
          return {'success': true, 'newState': true, 'message': response.message};
        } else {
          followError(response.message ?? 'Failed to follow user');
          return {'success': false, 'newState': currentFollowState, 'message': response.message ?? 'Failed to follow user'};
        }
      }
    } catch (e) {
      final errorMessage = 'Error ${currentFollowState ? "unfollowing" : "following"} user: $e';
      followError(errorMessage);
      print('Exception in toggleFollowUser: $e');
      return {'success': false, 'newState': currentFollowState, 'message': errorMessage};
    } finally {
      isFollowingInProgress(false);
    }
  }



  /// Get posts and polls from API
  Future<Map<String, dynamic>> _getPostsAndPolls() async {
    try {
      const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjcwODQzNjEwNzciLCJfaWQiOiI2ODcwYmI0NWQwMzNiMzQxY2E5NTY0NWEiLCJpYXQiOjE3NTI3NDE5ODYsImV4cCI6MTc1MjgyODM4Nn0.GGuFwvFsfvFYTg49xyhubYyIfnheZV-xnS7xc6ns3FI";
      final response = await http.get(
        Uri.parse('https://gamsgroup.in/api/user/post/get-post-polls'),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Failed to fetch posts and polls: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }


  /// Load followed users from local storage
  Future<void> _loadFollowedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final followedUsersJson = prefs.getString('followed_users');
      if (followedUsersJson != null) {
        final dynamic decodedData = json.decode(followedUsersJson);
        if (decodedData is Map<String, dynamic>) {
          followedUsers.clear();
          decodedData.forEach((key, value) {
            followedUsers[key] = value == true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading followed users: $e');
    }
  }

  /// Save followed users to local storage
  Future<void> _saveFollowedUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final followedUsersJson = json.encode(followedUsers);
      await prefs.setString('followed_users', followedUsersJson);
    } catch (e) {
      debugPrint('Error saving followed users: $e');
    }
  }
}
