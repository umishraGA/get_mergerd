// Example usage of the Dio setup
// This file demonstrates how to use the ApiService and DioClient

import 'package:dio/dio.dart';

import 'api_service.dart';
import 'auth_helper.dart';
import 'dio_client.dart';
import 'exceptions/api_exception.dart';

class ExampleApiRepository {
  final ApiService _apiService = ApiService();

  // Example: Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        parser: (data) => data as Map<String, dynamic>,
      );

      // Save auth token after successful login
      if (response['token'] != null) {
        await AuthHelper.saveAuthResponse(
          token: response['token'] as String,
          refreshToken: response['refresh_token'] as String?,
          userId: response['user']?['id']?.toString(),
          isProfileCompleted: response['isComplete'] as bool? ?? false,
        );
      }

      return response;
    } on ApiException catch (e) {
      // Handle API errors
      rethrow;
    }
  }

  // Example: Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      return await _apiService.getData<Map<String, dynamic>>(
        '/user/profile',
        parser: (data) => data as Map<String, dynamic>,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Example: Get list of posts
  Future<List<Post>> getPosts({int page = 1, int limit = 10}) async {
    try {
      return await _apiService.getList<Post>(
        '/posts',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        itemParser: (item) => Post.fromJson(item),
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Example: Upload image
  Future<Map<String, dynamic>> uploadImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      return await _apiService.upload<Map<String, dynamic>>(
        '/upload/image',
        formData,
        parser: (data) => data as Map<String, dynamic>,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Example: Update user profile
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      return await _apiService.put<Map<String, dynamic>>(
        '/user/profile',
        data: profileData,
        parser: (data) => data as Map<String, dynamic>,
      );
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Example: Delete post
  Future<bool> deletePost(int postId) async {
    try {
      return await _apiService.getSuccess('/posts/$postId');
    } on ApiException catch (e) {
      rethrow;
    }
  }

  // Example: Direct Dio usage (for more complex scenarios)
  Future<Response> customRequest() async {
    try {
      final dio = DioClient.instance.dio;
      return await dio.get('/custom-endpoint');
    } on DioException catch (e) {
      throw ApiException(
        message: e.message ?? 'Custom request failed',
        statusCode: e.response?.statusCode ?? 0,
      );
    }
  }
}

// Example model class
class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Example usage in a widget or controller
class ExampleUsage {
  final ExampleApiRepository _repository = ExampleApiRepository();

  Future<void> loginExample() async {
    try {
      final result = await _repository.login('user@example.com', 'password');
      print('Login successful: $result');
    } on ApiException catch (e) {
      print('Login failed: ${e.message}');
      // Handle specific error codes
      if (e.statusCode == 401) {
        print('Invalid credentials');
      } else if (e.statusCode == 422) {
        print('Validation error');
      }
    }
  }

  Future<void> getPostsExample() async {
    try {
      final posts = await _repository.getPosts(page: 1, limit: 20);
      print('Retrieved ${posts.length} posts');
    } on ApiException catch (e) {
      print('Failed to get posts: ${e.message}');
    }
  }

  Future<void> uploadImageExample(String imagePath) async {
    try {
      final result = await _repository.uploadImage(imagePath);
      print('Image uploaded: ${result['url']}');
    } on ApiException catch (e) {
      print('Upload failed: ${e.message}');
    }
  }
}
