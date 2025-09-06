// class VendorDetailsResponse {
//   final int statusCode;
//   final VendorDetails data;
//   final String message;
//   final bool success;
//
//   VendorDetailsResponse({
//     required this.statusCode,
//     required this.data,
//     required this.message,
//     required this.success,
//   });
//
//   factory VendorDetailsResponse.fromJson(Map<String, dynamic> json) {
//     return VendorDetailsResponse(
//       statusCode: json['statusCode'] ?? 0,
//       data: VendorDetails.fromJson(json['data'] ?? {}),
//       message: json['message'] ?? '',
//       success: json['success'] ?? false,
//     );
//   }
// }
//
// class VendorDetails {
//   final CompanyInfo companyInfo;
//   final ContactInfo contactInfo;
//   final LocationInfo locationInfo;
//   final GoogleLocation googleLocation;
//   final SocialLinks socialLinks;
//   final CoverImage coverImage;
//   final String id;
//   final bool displayHours;
//   final List<String> paymentOptions;
//   final BankerName bankerName;
//   final List<String> keywords;
//   final String vendorId;
//   final String status;
//   final bool isCompleted;
//   final int steps;
//   final List<String> coupons;
//   final Map<String, dynamic> attributes;
//   final List<BusinessHour> businessHours;
//   final List<BusinessImage> businessImages;
//   final String createdBy;
//   final int v;
//   final String refreshToken;
//   final String updatedBy;
//   final List<dynamic> followerMap;
//   final int followers;
//   final bool isFollowed;
//
//   VendorDetails({
//     required this.companyInfo,
//     required this.contactInfo,
//     required this.locationInfo,
//     required this.googleLocation,
//     required this.socialLinks,
//     required this.coverImage,
//     required this.id,
//     required this.displayHours,
//     required this.paymentOptions,
//     required this.bankerName,
//     required this.keywords,
//     required this.vendorId,
//     required this.status,
//     required this.isCompleted,
//     required this.steps,
//     required this.coupons,
//     required this.attributes,
//     required this.businessHours,
//     required this.businessImages,
//     required this.createdBy,
//     required this.v,
//     required this.refreshToken,
//     required this.updatedBy,
//     required this.followerMap,
//     required this.followers,
//     required this.isFollowed,
//   });
//
//   factory VendorDetails.fromJson(Map<String, dynamic> json) {
//     return VendorDetails(
//       companyInfo: CompanyInfo.fromJson(json['companyInfo'] ?? {}),
//       contactInfo: ContactInfo.fromJson(json['contactInfo'] ?? {}),
//       locationInfo: LocationInfo.fromJson(json['locationInfo'] ?? {}),
//       googleLocation: GoogleLocation.fromJson(json['googleLocation'] ?? {}),
//       socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
//       coverImage: CoverImage.fromJson(json['coverImage'] ?? {}),
//       id: json['_id'] ?? '',
//       displayHours: json['displayHours'] ?? false,
//       paymentOptions: (json['paymentOptions'] as List? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//       bankerName: BankerName.fromJson(json['bankerName'] ?? {}),
//       keywords: (json['keywords'] as List? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//       vendorId: json['vendorId'] ?? '',
//       status: json['status'] ?? '',
//       isCompleted: json['isCompleted'] ?? false,
//       steps: json['steps'] ?? 0,
//       coupons: (json['coupons'] as List? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//       attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
//       businessHours: (json['businessHours'] as List? ?? [])
//           .map((e) => BusinessHour.fromJson(e ?? {}))
//           .toList(),
//       businessImages: (json['businessImages'] as List? ?? [])
//           .map((e) => BusinessImage.fromJson(e ?? {}))
//           .toList(),
//       createdBy: json['createdBy'] ?? '',
//       v: json['__v'] ?? 0,
//       refreshToken: json['refreshToken'] ?? '',
//       updatedBy: json['updatedBy'] ?? '',
//       followerMap: json['followerMap'] as List? ?? [],
//       followers: json['followers'] ?? 0,
//       isFollowed: json['isFollowed'] ?? false,
//     );
//   }
// }
//
// class CompanyInfo {
//   final String companyName;
//   final String establishYear;
//   final String companyCeo;
//   final BusinessNature businessNature;
//   final BusinessCategory businessCategory;
//   final EmployeeNumber employeeNumber;
//   final BusinessLegal businessLegal;
//   final dynamic gstTurnOver; // Could be null or various types
//   final dynamic companyWebsite; // Could be null or various types
//   final String aboutUs;
//
//   CompanyInfo({
//     required this.companyName,
//     required this.establishYear,
//     required this.companyCeo,
//     required this.businessNature,
//     required this.businessCategory,
//     required this.employeeNumber,
//     required this.businessLegal,
//     required this.gstTurnOver,
//     required this.companyWebsite,
//     required this.aboutUs,
//   });
//
//   factory CompanyInfo.fromJson(Map<String, dynamic> json) {
//     return CompanyInfo(
//       companyName: json['companyName'] ?? '',
//       establishYear: json['establishYear'] ?? '',
//       companyCeo: json['companyCeo'] ?? '',
//       businessNature: BusinessNature.fromJson(json['businessNature'] ?? {}),
//       businessCategory: BusinessCategory.fromJson(json['businessCategory'] ?? {}),
//       employeeNumber: EmployeeNumber.fromJson(json['employeeNumber'] ?? {}),
//       businessLegal: BusinessLegal.fromJson(json['businessLegal'] ?? {}),
//       gstTurnOver: json['gstTurnOver'],
//       companyWebsite: json['companyWebsite'],
//       aboutUs: json['aboutUs'] ?? '',
//     );
//   }
// }
//
// class BusinessNature {
//   final String name;
//
//   BusinessNature({required this.name});
//
//   factory BusinessNature.fromJson(Map<String, dynamic> json) {
//     return BusinessNature(name: json['name'] ?? '');
//   }
// }
//
// class BusinessCategory {
//   final String name;
//
//   BusinessCategory({required this.name});
//
//   factory BusinessCategory.fromJson(Map<String, dynamic> json) {
//     return BusinessCategory(name: json['name'] ?? '');
//   }
// }
//
// class EmployeeNumber {
//   final String name;
//
//   EmployeeNumber({required this.name});
//
//   factory EmployeeNumber.fromJson(Map<String, dynamic> json) {
//     return EmployeeNumber(name: json['name'] ?? '');
//   }
// }
//
// class BusinessLegal {
//   final String name;
//
//   BusinessLegal({required this.name});
//
//   factory BusinessLegal.fromJson(Map<String, dynamic> json) {
//     return BusinessLegal(name: json['name'] ?? '');
//   }
// }
//
// class ContactInfo {
//   final dynamic homeLandline;
//   final dynamic officeLandline;
//   final dynamic tollFreeNumber;
//   final dynamic email;
//   final String phoneNo;
//   final dynamic alternateNo;
//   final bool isPhoneVerify;
//   final bool isEmailVerify;
//   final bool isAlternateVerify;
//
//   ContactInfo({
//     required this.homeLandline,
//     required this.officeLandline,
//     required this.tollFreeNumber,
//     required this.email,
//     required this.phoneNo,
//     required this.alternateNo,
//     required this.isPhoneVerify,
//     required this.isEmailVerify,
//     required this.isAlternateVerify,
//   });
//
//   factory ContactInfo.fromJson(Map<String, dynamic> json) {
//     return ContactInfo(
//       homeLandline: json['homeLandline'],
//       officeLandline: json['officeLandline'],
//       tollFreeNumber: json['tollFreeNumber'],
//       email: json['email'],
//       phoneNo: json['phoneNo'] ?? '',
//       alternateNo: json['alternateNo'],
//       isPhoneVerify: json['isPhoneVerify'] ?? false,
//       isEmailVerify: json['isEmailVerify'] ?? false,
//       isAlternateVerify: json['isAlternateVerify'] ?? false,
//     );
//   }
// }
//
// class LocationInfo {
//   final String country;
//   final String state;
//   final String city;
//   final String area;
//   final int pincode;
//   final String address;
//
//   LocationInfo({
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.area,
//     required this.pincode,
//     required this.address,
//   });
//
//   factory LocationInfo.fromJson(Map<String, dynamic> json) {
//     return LocationInfo(
//       country: json['country'] ?? '',
//       state: json['state'] ?? '',
//       city: json['city'] ?? '',
//       area: json['area'] ?? '',
//       pincode: json['pincode'] ?? 0,
//       address: json['address'] ?? '',
//     );
//   }
// }
//
// class GoogleLocation {
//   final String latitude;
//   final String longitude;
//
//   GoogleLocation({required this.latitude, required this.longitude});
//
//   factory GoogleLocation.fromJson(Map<String, dynamic> json) {
//     return GoogleLocation(
//       latitude: json['latitude'] ?? '',
//       longitude: json['longitude'] ?? '',
//     );
//   }
//
//   // Helper method to get coordinates as double
//   double get latAsDouble => double.tryParse(latitude) ?? 0.0;
//   double get lngAsDouble => double.tryParse(longitude) ?? 0.0;
// }
//
// class SocialLinks {
//   final String facebook;
//   final dynamic twitter;
//   final dynamic instagram;
//   final dynamic linkedIn;
//   final dynamic youTube;
//   final dynamic pinterest;
//
//   SocialLinks({
//     required this.facebook,
//     required this.twitter,
//     required this.instagram,
//     required this.linkedIn,
//     required this.youTube,
//     required this.pinterest,
//   });
//
//   factory SocialLinks.fromJson(Map<String, dynamic> json) {
//     return SocialLinks(
//       facebook: json['facebook'] ?? '',
//       twitter: json['twitter'],
//       instagram: json['instagram'],
//       linkedIn: json['linkedIn'],
//       youTube: json['youTube'],
//       pinterest: json['pinterest'],
//     );
//   }
// }
//
// class CoverImage {
//   final dynamic reason;
//   final String url;
//   final String status;
//
//   CoverImage({required this.reason, required this.url, required this.status});
//
//   factory CoverImage.fromJson(Map<String, dynamic> json) {
//     return CoverImage(
//       reason: json['reason'],
//       url: json['url'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }
//
// class BankerName {
//   final String name;
//
//   BankerName({required this.name});
//
//   factory BankerName.fromJson(Map<String, dynamic> json) {
//     return BankerName(name: json['name'] ?? '');
//   }
// }
//
// class BusinessHour {
//   final String day;
//   final String openTime;
//   final String closeTime;
//   final bool isClosed;
//   final bool isOpen24Hours;
//   final String id;
//
//   BusinessHour({
//     required this.day,
//     required this.openTime,
//     required this.closeTime,
//     required this.isClosed,
//     required this.isOpen24Hours,
//     required this.id,
//   });
//
//   factory BusinessHour.fromJson(Map<String, dynamic> json) {
//     return BusinessHour(
//       day: json['day']?.toString() ?? '',
//       openTime: json['openTime']?.toString()  ?? '',
//       closeTime: json['closeTime']?.toString()  ?? '',
//       isClosed: json['isClosed']as bool ?? false,
//       isOpen24Hours: json['isOpen24Hours']as bool ?? false,
//       id: json['_id']?.toString()  ?? '',
//     );
//   }
// }
//
// class BusinessImage {
//   final String url;
//   final dynamic reason;
//   final String status;
//   final String id;
//
//   BusinessImage({
//     required this.url,
//     required this.reason,
//     required this.status,
//     required this.id,
//   });
//
//   factory BusinessImage.fromJson(Map<String, dynamic> json) {
//     return BusinessImage(
//       url: json['url'] ?? '',
//       reason: json['reason'],
//       status: json['status'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
// }