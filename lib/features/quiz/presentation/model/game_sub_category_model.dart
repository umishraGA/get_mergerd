class SubCategoryResponse {
  int? statusCode;
  List<SubCategory>? data;
  String? message;
  bool? success;

  SubCategoryResponse({this.statusCode, this.data, this.message, this.success});

  SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    // Parse statusCode safely
    statusCode = json["statusCode"] != null
        ? int.tryParse(json["statusCode"].toString())
        : null;

    // Parse data list safely
    if (json["data"] != null && json["data"] is List) {
      data = <SubCategory>[];
      for (var v in json["data"] as List) {
        if (v != null && v is Map<String, dynamic>) {
          data!.add(SubCategory.fromJson(v));
        }
      }
    }

    // Parse message
    message = json["message"]?.toString();

    // Parse success safely
    if (json["success"] != null) {
      if (json["success"] is bool) {
        success = json["success"] as bool;
      } else if (json["success"] is int) {
        success = (json["success"] as int) == 1;
      } else {
        success = json["success"].toString().toLowerCase() == 'true';
      }
    }
  }
}

class SubCategory {
  String? id;
  int? sortId;
  String? categoryId;
  String? categoryName;
  String? slug;
  String? icon;
  String? status;
  String? user;
  String? createdAt;
  String? updatedAt;

  SubCategory({
    this.id,
    this.sortId,
    this.categoryId,
    this.categoryName,
    this.slug,
    this.icon,
    this.status,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json["_id"]?.toString();
    sortId = json["sort_id"] != null ? int.tryParse(json["sort_id"].toString()) : null;
    categoryId = json["categoryId"]?.toString();
    categoryName = json["categoryName"]?.toString();
    slug = json["slug"]?.toString();
    icon = json["icon"]?.toString();
    status = json["status"]?.toString();
    user = json["user"]?.toString();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["sort_id"] = sortId;
    data["categoryId"] = categoryId;
    data["categoryName"] = categoryName;
    data["slug"] = slug;
    data["icon"] = icon;
    data["status"] = status;
    data["user"] = user;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    return data;
  }
}
