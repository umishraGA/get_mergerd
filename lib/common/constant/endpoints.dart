class Endpoints {
  Endpoints._();

  static const String baseUrl = "https://api.gamsgroup.in";


  static const int receiveTimeout = 30000;
  static const int connectionTimeout = 30000;
  static const int sendTimeout = 30000;

  static const String signupOtp = '$baseUrl/user/auth/signup-otp';
  static const String verifySignupOtp = '$baseUrl/user/auth/verify-signup';
  static const String loginOtp = '$baseUrl/user/auth/login-otp';
  static const String verifyLoginOtp = '$baseUrl/user/auth/verify-login';
  static const String getPostPolls = '$baseUrl/user/post/get-post-polls';
  static const String getFollowingPost = '$baseUrl/user/post/get-followe-post';

  // Comment endpoints
  static const String getPostComment = '$baseUrl/user/post/get-post-comment';
  static const String addPostComment = '$baseUrl/user/post/post-comment';
  static const String updateComment = '$baseUrl/user/post/update-comment';
  static const String deleteComment = '$baseUrl/user/post/delete-comment';
  
  // Like endpoints
  static const String likePost = '$baseUrl/user/post/like-post';
  static const String likePolls = '$baseUrl/user/post/like-polls';

  static const String addVote = '$baseUrl/user/post/add-vote';

  // Reaction endpoints
  static const String addReaction = '$baseUrl/user/post/add-reaction';
  static const String addPollsReaction = '$baseUrl/user/post/add-polls-reaction';
  
  // Report and Save endpoints
  static const String createPostPollsStoryReport = '$baseUrl/user/post/create-post-polls-story-report';
  static const String savePost = '$baseUrl/user/post/save-post';
  static const String getSavePost = '$baseUrl/user/post/get-save-post';
  
  // Story endpoints
  static const String getStory = '$baseUrl/user/post/get-story';
  static const String likeStory = '$baseUrl/user/post/like-story';
  static const String addStoryReaction = '$baseUrl/user/post/add-story-reaction';
  
  // Follow endpoints (both use the same endpoint - API toggles based on current state)
  static const String followUser = '$baseUrl/user/post/follow';
  static const String unfollowUser = '$baseUrl/user/post/follow';

  // Utsav/Coupon endpoints
  static const String getCouponCategories = '$baseUrl/user/coupon/category';
  static const String getCategoryCoupons = '$baseUrl/user/coupon/category-coupons';
  static const String getBusinessCoupons = '$baseUrl/user/coupon/business-coupons';
  static const String getCouponBanner = '$baseUrl/user/coupon/banner';
  static const String getHomeBanner = '$baseUrl/user/coupon/homeBanner';
  static const String generateCouponCode = '$baseUrl/user/coupon/gen-code';
  static const String redeemCoupon = '$baseUrl/user/coupon/redeem';
  static const String getRedeemHistory = '$baseUrl/user/coupon/redeemHistory';
  static const String searchCoupons = '$baseUrl/user/coupon/search';

  static const String getAddress = '$baseUrl/user/basic/get-address';
  static const String saveEnquiry = '$baseUrl/user/basic/save-enquiry';

}