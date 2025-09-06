import 'UtsavRepository.dart';
import 'models/CouponCategoryModels.dart';
import 'models/CategoryCouponsModels.dart';
import 'models/BusinessCouponsModels.dart';
import 'models/CouponBannerModels.dart';
import 'models/CouponCodeModels.dart';
import 'models/HomeBannerModels.dart';
import 'models/RedeemHistoryModels.dart';
import 'models/SearchModels.dart';
import '../listings/models/EnquiryModels.dart';

class UtsavViewModel {
  final UtsavRepository _repository;
  
  UtsavViewModel({required UtsavRepository repository}) : _repository = repository;

  Future<CouponCategoryResponse> getCouponCategories() async {
    return await _repository.getCouponCategories();
  }

  Future<CategoryCouponsResponse> getCategoryCoupons(CategoryCouponsRequest request) async {
    return await _repository.getCategoryCoupons(request);
  }

  Future<BusinessCouponsResponse> getBusinessCoupons(BusinessCouponsRequest request) async {
    return await _repository.getBusinessCoupons(request);
  }

  Future<CouponBannerResponse> getCouponBanner(CouponBannerRequest request) async {
    return await _repository.getCouponBanner(request);
  }

  Future<CouponCodeResponse> generateCouponCode(GenerateCouponCodeRequest request) async {
    return await _repository.generateCouponCode(request);
  }

  Future<CouponCodeResponse> redeemCoupon(RedeemCouponRequest request) async {
    return await _repository.redeemCoupon(request);
  }

  Future<HomeBannerResponse> getHomeBanners({
    required String latitude,
    required String longitude,
  }) async {
    return await _repository.getHomeBanners(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<RedeemHistoryResponse> getRedeemHistory() async {
    return await _repository.getRedeemHistory();
  }

  Future<SearchResponse> searchCoupons(SearchRequest request) async {
    return await _repository.searchCoupons(request);
  }

  Future<SaveEnquiryResponse> saveEnquiry(SaveEnquiryRequest request) async {
    return await _repository.saveEnquiry(request);
  }
}