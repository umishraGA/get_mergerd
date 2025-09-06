class CategoryLevelModel {
  int? statusCode;
  List<CategoryLevelData>? data;
  String? message;
  bool? success;

  CategoryLevelModel({this.statusCode, this.data, this.message, this.success});

  factory CategoryLevelModel.fromJson(Map<String, dynamic> json) {
    return CategoryLevelModel(
      statusCode: json["statusCode"] as int,
      data: (json["data"] != null && json["data"] is List)
          ? (json["data"] as List)
          .map((item) => CategoryLevelData.fromJson(item as Map<String, dynamic>))
          .toList()
          : [],
      message: json["message"] as String,
      success: json["success"] as bool,

    );
  }

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "data": data?.map((x) => x.toJson()).toList(),
    "message": message,
    "success": success,
  };
}

class CategoryLevelData {
  String? id;
  String? title;
  int? entryFee;
  String? terms;
  int? level;
  int? questionCount;
  bool levelUnlocked; // Non-nullable, default false

  CategoryLevelData({
    this.id,
    this.title,
    this.entryFee,
    this.terms,
    this.level,
    this.questionCount,
    this.levelUnlocked = false,
  });

  factory CategoryLevelData.fromJson(Map<String, dynamic> json) {
    return CategoryLevelData(
      id: json["_id"] as String,
      title: json["title"] as String,
      entryFee: json["entry_fee"] as int,
      terms: json["terms"] as String,
      level: json["level"] as int,
      questionCount: json["questionCount"] as int,
      levelUnlocked: json["levelUnlocked"] != null
          ? json["levelUnlocked"] as bool
          : false,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "entry_fee": entryFee,
    "terms": terms,
    "level": level,
    "questionCount": questionCount,
    "levelUnlocked": levelUnlocked,
  };
}
