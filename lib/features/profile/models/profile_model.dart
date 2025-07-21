class ProfileModel {
  final String name;
  final String phone;
  final bool isVerified;
  final String userType;
  final String? profileImageUrl;
  final bool isProfileComplete;

  ProfileModel({
    required this.name,
    required this.phone,
    this.isVerified = false,
    this.userType = '',
    this.profileImageUrl,
    this.isProfileComplete = false,
  });

  // Factory method to create profile from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      isVerified: json['is_verified'] == true,
      userType: json['user_type']?.toString() ?? '',
      profileImageUrl: json['profile_image_url']?.toString(),
      isProfileComplete: json['is_profile_complete'] == true,
    );
  }

  // Convert profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'is_verified': isVerified,
      'user_type': userType,
      'profile_image_url': profileImageUrl,
      'is_profile_complete': isProfileComplete,
    };
  }
}
