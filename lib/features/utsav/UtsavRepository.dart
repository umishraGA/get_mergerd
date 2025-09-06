import 'package:shared_preferences/shared_preferences.dart';
import '../../common/constant/endpoints.dart';
import '../../utils/dio/api_service.dart';
import '../../utils/dio/auth_helper.dart';
import 'models/CouponCategoryModels.dart';
import 'models/CategoryCouponsModels.dart';
import 'models/BusinessCouponsModels.dart';
import 'models/CouponBannerModels.dart';
import 'models/CouponCodeModels.dart';
import 'models/HomeBannerModels.dart';
import 'models/RedeemHistoryModels.dart';
import 'models/SearchModels.dart';
import '../listings/models/EnquiryModels.dart';

class UtsavRepository {
  final ApiService _apiService;
  
  UtsavRepository({required ApiService apiService}) : _apiService = apiService;

  Future<String?> _getBearerToken() async {
    try {
      final token = AuthHelper.getAuthToken;
      return "Bearer $token";
    } catch (e) {
      return null;
    }
  }

  Future<CouponCategoryResponse> getCouponCategories() async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<CouponCategoryResponse>(
        Endpoints.getCouponCategories,
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            CouponCategoryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<CategoryCouponsResponse> getCategoryCoupons(CategoryCouponsRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<CategoryCouponsResponse>(
        Endpoints.getCategoryCoupons,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            CategoryCouponsResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<BusinessCouponsResponse> getBusinessCoupons(BusinessCouponsRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<BusinessCouponsResponse>(
        Endpoints.getBusinessCoupons,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            BusinessCouponsResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<CouponBannerResponse> getCouponBanner(CouponBannerRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<CouponBannerResponse>(
        Endpoints.getCouponBanner,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            CouponBannerResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<CouponCodeResponse> generateCouponCode(GenerateCouponCodeRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<CouponCodeResponse>(
        Endpoints.generateCouponCode,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            CouponCodeResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<CouponCodeResponse> redeemCoupon(RedeemCouponRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<CouponCodeResponse>(
        Endpoints.redeemCoupon,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            CouponCodeResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<HomeBannerResponse> getHomeBanners({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<HomeBannerResponse>(
        Endpoints.getHomeBanner,
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            HomeBannerResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<RedeemHistoryResponse> getRedeemHistory() async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.get<RedeemHistoryResponse>(
        Endpoints.getRedeemHistory,
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            RedeemHistoryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<SearchResponse> searchCoupons(SearchRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<SearchResponse>(
        Endpoints.searchCoupons,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            SearchResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<SaveEnquiryResponse> saveEnquiry(SaveEnquiryRequest request) async {
    try {
      final token = await _getBearerToken();
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      return await _apiService.post<SaveEnquiryResponse>(
        Endpoints.saveEnquiry,
        data: request.toJson(),
        headers: {
          'Authorization': token,
        },
        parser: (data) =>
            SaveEnquiryResponse.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}