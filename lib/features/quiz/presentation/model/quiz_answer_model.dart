class QuizAnswerDataModel {
  int? statusCode;
  QuizAnswerData? data;
  String? message;
  bool? success;

  QuizAnswerDataModel({this.statusCode, this.data, this.message, this.success});

  factory QuizAnswerDataModel.fromJson(Map<String, dynamic> json) {
    return QuizAnswerDataModel(
      statusCode: json["statusCode"] != null ? int.tryParse(json["statusCode"].toString()) : null,
      data: (json["data"] != null && json["data"] is Map<String, dynamic>)
          ? QuizAnswerData.fromJson(json["data"] as Map<String, dynamic>)
          : null,
      message: json["message"]?.toString(),
      success: json["success"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "data": data?.toJson(),
      "message": message,
      "success": success,
    };
  }
}

class QuizAnswerData {
  String? id;
  String? user;
  String? userModal;
  String? levelid;
  bool? nextLevelUnlocked;
  String? levelmodal;
  bool? skipped;
  String? questionModal;
  List<Answered>? answered;
  int? score;
  String? status;
  int? rightanswerCount;
  String? createdAt;
  String? updatedAt;
  int? v;

  QuizAnswerData({
    this.id,
    this.user,
    this.userModal,
    this.levelid,
    this.nextLevelUnlocked,
    this.levelmodal,
    this.skipped,
    this.questionModal,
    this.answered,
    this.score,
    this.status,
    this.rightanswerCount,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory QuizAnswerData.fromJson(Map<String, dynamic> json) {
    return QuizAnswerData(
      id: json["_id"]?.toString(),
      user: json["user"]?.toString(),
      userModal: json["userModal"]?.toString(),
      levelid: json["levelid"]?.toString(),
      nextLevelUnlocked: json["nextLevelUnlocked"] as bool?,
      levelmodal: json["levelmodal"]?.toString(),
      skipped: json["skipped"] as bool?,
      questionModal: json["questionModal"]?.toString(),
      answered: json["answered"] != null
          ? (json["answered"] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Answered.fromJson(e))
          .toList()
          : null,
      score: json["score"] != null ? int.tryParse(json["score"].toString()) : null,
      status: json["status"]?.toString(),
      rightanswerCount: json["rightanswerCount"] != null
          ? int.tryParse(json["rightanswerCount"].toString())
          : null,
      createdAt: json["createdAt"]?.toString(),
      updatedAt: json["updatedAt"]?.toString(),
      v: json["__v"] != null ? int.tryParse(json["__v"].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user,
      "userModal": userModal,
      "levelid": levelid,
      "nextLevelUnlocked": nextLevelUnlocked,
      "levelmodal": levelmodal,
      "skipped": skipped,
      "questionModal": questionModal,
      "answered": answered?.map((e) => e.toJson()).toList(),
      "score": score,
      "status": status,
      "rightanswerCount": rightanswerCount,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class Answered {
  String? question;
  String? answer;
  String? id;

  Answered({this.question, this.answer, this.id});

  factory Answered.fromJson(Map<String, dynamic> json) {
    return Answered(
      question: json["question"]?.toString(),
      answer: json["answer"]?.toString(),
      id: json["_id"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer": answer,
      "_id": id,
    };
  }
}
