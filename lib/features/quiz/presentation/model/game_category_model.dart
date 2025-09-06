class QuizCategoryDataModel {
  int? statusCode;
  List<QuizCategoryData>? data;
  String? message;
  bool? success;

  QuizCategoryDataModel({this.statusCode, this.data, this.message, this.success});

  QuizCategoryDataModel.fromJson(Map<String, dynamic> json) {
    // Parse statusCode safely
    statusCode = json["statusCode"] != null
        ? int.tryParse(json["statusCode"].toString())
        : null;

    // Parse data list safely
    if (json["data"] != null && json["data"] is List) {
      data = <QuizCategoryData>[];
      for (var v in json["data"] as List) {
        // Check if v is Map<String, dynamic>
        if (v != null && v is Map<String, dynamic>) {
          data!.add(QuizCategoryData.fromJson(v));
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

class QuizCategoryData {
  String? id;
  String? categoryName;
  String? icon;
  String? type;

  QuizCategoryData({this.id, this.categoryName, this.icon, this.type});

  QuizCategoryData.fromJson(Map<String, dynamic> json) {
    id = json["_id"]?.toString();
    categoryName = json["categoryName"]?.toString();
    icon = json["icon"]?.toString();
    type = json["type"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["categoryName"] = categoryName;
    data["icon"] = icon;
    data["type"] = type;
    return data;
  }
}

