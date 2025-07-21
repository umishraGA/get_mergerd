import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../test.dart';

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
          ? (json['options'] as List<dynamic>).map((e) => Option.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      chooseType: json['chooseType']?.toString() ?? '',
      locution: json['locution']?.toString() ?? '',
      locutionkm: (json['locutionkm'] ?? json['locationKm'])?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
      latCoordinate: _parseDouble(json['latCoordinage'] ?? json['latCoordinate']),
      lngCoordinate: _parseDouble(json['langCoordinagee'] ?? json['lngCoordinate']),
      createdBy: json['createdBy']?.toString() ?? '',
      images: json['images'] != null
          ? (json['images'] as List<dynamic>).map((e) => ImageModel.fromJson(e as Map<String, dynamic>)).toList()
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

class ApiService {
  static const String baseUrl = 'https://gamsgroup.in/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bearer_token');
  }

  static Future<Map<String, dynamic>> getPostsAndPolls() async {
    try {
      final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjcwODQzNjEwNzciLCJfaWQiOiI2ODcwYmI0NWQwMzNiMzQxY2E5NTY0NWEiLCJpYXQiOjE3NTI3NDE5ODYsImV4cCI6MTc1MjgyODM4Nn0.GGuFwvFsfvFYTg49xyhubYyIfnheZV-xnS7xc6ns3FI";
      final response = await http.get(
        Uri.parse('$baseUrl/user/post/get-post-polls'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Failed to fetch posts and polls: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

class PostController extends GetxController {
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      error('');

      final Map<String, dynamic> response = await ApiService.getPostsAndPolls();

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] as List<dynamic>;
        posts.value = data.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        error(response['message']?.toString() ?? 'Failed to fetch posts');
      }
    } catch (e) {
      error('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  void voteOnPoll(String postId, String optionId) {
    final postIndex = posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = posts[postIndex];
      if (post.options != null) {
        final optionIndex = post.options!.indexWhere((option) => option.id == optionId);
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
}

