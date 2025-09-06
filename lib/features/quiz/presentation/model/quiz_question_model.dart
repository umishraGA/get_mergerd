class QuizQuestionModel {
  int? statusCode;
  LevelData? levelData;
  List<QuizQuestionData>? allData;
  String? message;
  bool? success;

  QuizQuestionModel({this.statusCode, this.levelData, this.allData, this.message, this.success});

  QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"] != null
        ? int.tryParse(json["statusCode"].toString())
        : null;

    if (json["data"] != null && json["data"] is Map<String, dynamic>) {
      final data = json["data"] as Map<String, dynamic>;

      if (data["leveldata"] != null) {
        final levelDataJson = data["leveldata"];
        if (levelDataJson is Map<String, dynamic>) {
          levelData = LevelData.fromJson(levelDataJson);
        }
      }

      if (data["alldata"] != null && data["alldata"] is List) {
        allData = (data["alldata"] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => QuizQuestionData.fromJson(e))
            .toList();
      }
    }

    message = json["message"]?.toString();

    if (json["success"] != null) {
      if (json["success"] is bool) {
        success = json["success"] as bool;
      } else if (json["success"] is int) {
        success = (json["success"] as int) == 1;
      } else {
        success = json["success"].toString().toLowerCase() == "true";
      }
    }
  }
}

class LevelData {
  String? id;
  int? quesDuration;
  int? freeBombPerLevel;
  int? bombDeductCoins;
  int? freePollPerLevel;
  int? pollDeductCoins;
  int? freeAddTime;
  int? addTimeDeductCoins;
  int? freeSkip;
  int? skipDeductCoins;

  LevelData({
    this.id,
    this.quesDuration,
    this.freeBombPerLevel,
    this.bombDeductCoins,
    this.freePollPerLevel,
    this.pollDeductCoins,
    this.freeAddTime,
    this.addTimeDeductCoins,
    this.freeSkip,
    this.skipDeductCoins,
  });

  LevelData.fromJson(Map<String, dynamic> json) {
    id = json["_id"]?.toString();
    quesDuration = json["ques_duration"] != null ? int.tryParse(json["ques_duration"].toString()) : null;
    freeBombPerLevel = json["free_bomb_per_level"] != null ? int.tryParse(json["free_bomb_per_level"].toString()) : null;
    bombDeductCoins = json["bomb_deduct_Coins"] != null ? int.tryParse(json["bomb_deduct_Coins"].toString()) : null;
    freePollPerLevel = json["free_poll_per_level"] != null ? int.tryParse(json["free_poll_per_level"].toString()) : null;
    pollDeductCoins = json["poll_deduct_Coins"] != null ? int.tryParse(json["poll_deduct_Coins"].toString()) : null;
    freeAddTime = json["free_add_time"] != null ? int.tryParse(json["free_add_time"].toString()) : null;
    addTimeDeductCoins = json["add_time_deduct_Coins"] != null ? int.tryParse(json["add_time_deduct_Coins"].toString()) : null;
    freeSkip = json["free_skip"] != null ? int.tryParse(json["free_skip"].toString()) : null;
    skipDeductCoins = json["skip_deduct_Coins"] != null ? int.tryParse(json["skip_deduct_Coins"].toString()) : null;
  }
}

class QuizQuestionData {
  String? id;
  int? quesId;
  String? question;
  String? optionA;
  String? optionB;
  String? optionC;
  String? optionD;
  String? answer;
  String? icon;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? v;

  QuizQuestionData({
    this.id,
    this.quesId,
    this.question,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.answer,
    this.icon,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory QuizQuestionData.fromJson(Map<String, dynamic> json) {
    return QuizQuestionData(
      id: json["_id"]?.toString(),
      quesId: json["quesid"] != null ? int.tryParse(json["quesid"].toString()) : null,
      question: json["question"]?.toString(),
      optionA: json["optionA"]?.toString(),
      optionB: json["optionB"]?.toString(),
      optionC: json["optionC"]?.toString(),
      optionD: json["optionD"]?.toString(),
      answer: json["answer"]?.toString(),
      icon: json["icon"]?.toString(),
      user: json["user"]?.toString(),
      createdAt: json["createdAt"]?.toString(),
      updatedAt: json["updatedAt"]?.toString(),
      v: json["__v"] != null ? int.tryParse(json["__v"].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "quesid": quesId,
      "question": question,
      "optionA": optionA,
      "optionB": optionB,
      "optionC": optionC,
      "optionD": optionD,
      "answer": answer,
      "icon": icon,
      "user": user,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}
