import 'package:get/get.dart';

class ReviewModel {
  ReviewModel({
    this.allOverAvg,
    this.totalFeedBack,
    this.totalAvgRating,
    this.customerReview,
  });

  String allOverAvg;
  int totalFeedBack;
  List<TotalAvgRating> totalAvgRating;

  // ignore: deprecated_member_use
  var customerReview = List<CustomerReview>().obs;

  ReviewModel.fromJson(Map<String, dynamic> json) {
    allOverAvg = json["allOverAvg"];
    totalFeedBack = json["totalFeedBack"];
    totalAvgRating = List<TotalAvgRating>.from(
        json["totalAvgRating"].map((x) => TotalAvgRating.fromJson(x))).toList();
    customerReview.value = List<CustomerReview>.from(
        json["customerReview"].map((x) => CustomerReview.fromJson(x))).toList();
    customerReview.value.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Map<String, dynamic> toJson() => {
        "allOverAvg": allOverAvg,
        "totalFeedBack": totalFeedBack,
        "totalAvgRating":
            List<dynamic>.from(totalAvgRating.map((x) => x.toJson())),
        "customerReview":
            List<dynamic>.from(customerReview.map((x) => x.toJson())),
      };
}

class CustomerReview {
  CustomerReview(
      {this.id,
      this.userId,
      this.storeId,
      this.serviceRate,
      this.ambiente,
      this.preieLeistungsRate,
      this.wartezeit,
      this.atmosphare,
      this.writeComment,
      this.totalAvgRating,
      this.serviceId,
      this.empId,
      this.storeReplay,
      this.createdAt,
      this.updatedAt,
      this.empName,
      this.serviceName,
      this.userName,
      this.userImagePath,
      this.dayAgo,
      this.storeName,
      this.storeAddress});

  int id;
  int userId;
  int storeId;
  String serviceRate;
  String ambiente;
  String preieLeistungsRate;
  String wartezeit;
  String atmosphare;
  String writeComment;
  String totalAvgRating;
  int serviceId;
  int empId;
  dynamic storeReplay;
  DateTime createdAt;
  DateTime updatedAt;
  String empName;
  String serviceName;
  String userName;
  String userImagePath;
  String dayAgo;
  String storeName;
  String storeAddress;
  var isOpen = false.obs;
  var isOpenReplay = false.obs;
  var noProfilcePicData = "-";

  CustomerReview.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    storeId = json["store_id"];
    serviceRate = json["service_rate"];
    ambiente = json["ambiente"];
    preieLeistungsRate = json["preie_leistungs_rate"];
    wartezeit = json["wartezeit"];
    atmosphare = json["atmosphare"];
    writeComment = json["write_comment"];
    totalAvgRating = json["total_avg_rating"];
    serviceId = json["service_id"];
    empId = json["emp_id"];
    storeReplay = json["store_replay"];
    createdAt = DateTime.parse(json["created_at"]);
    updatedAt = DateTime.parse(json["updated_at"]);
    empName = json["emp_name"] ?? "";
    serviceName = json["service_name"] == null ? "" : json["service_name"];
    userName = json["user_name"];
    userImagePath =
        json["user_image_path"] == null ? null : json["user_image_path"];
    dayAgo = json["dayAgo"];
    storeName = json["store_name"];
    storeAddress = json["store_address"];
    print("userName $userName");

    if (userName.contains(" ")) {
      noProfilcePicData = userName;
    /*  if (userName == null || userName.trim().isNotEmpty) {
        var arrStr = userName.split(" ");
        if (arrStr.length > 0) {
          var first = arrStr.first.substring(0, 1).toUpperCase();
          noProfilcePicData = first;
          if (arrStr.length > 1) {
            var last = arrStr.last.substring(0, 1).toUpperCase();
            noProfilcePicData = first + last;
          }
        }
      }*/
    } else {
      noProfilcePicData = userName;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "store_id": storeId,
        "service_rate": serviceRate,
        "ambiente": ambiente,
        "preie_leistungs_rate": preieLeistungsRate,
        "wartezeit": wartezeit,
        "atmosphare": atmosphare,
        "write_comment": writeComment,
        "total_avg_rating": totalAvgRating,
        "service_id": serviceId,
        "emp_id": empId,
        "store_replay": storeReplay,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "emp_name": empName,
        "service_name": serviceName == null ? null : serviceName,
        "user_name": userName,
        "user_image_path": userImagePath == null ? null : userImagePath,
        "dayAgo": dayAgo,
      };

  static List<CustomerReview> getData(dynamic arrData) {
    List<CustomerReview> arrTemp = [];

    arrData.forEach((v) {
      arrTemp.add(new CustomerReview.fromJson(v));
    });

    return arrTemp;
  }
}

class TotalAvgRating {
  TotalAvgRating({
    this.serviceRate,
    this.ambiente,
    this.preieLeistungsRate,
    this.wartezeit,
    this.atmosphare,
  });

  String serviceRate;
  String ambiente;
  String preieLeistungsRate;
  String wartezeit;
  String atmosphare;

  TotalAvgRating.fromJson(Map<String, dynamic> json) {
    serviceRate = json["service_rate"];
    ambiente = json["ambiente"];
    preieLeistungsRate = json["preie_leistungs_rate"];
    wartezeit = json["wartezeit"];
    atmosphare = json["atmosphare"];
  }

  Map<String, dynamic> toJson() => {
        "service_rate": serviceRate,
        "ambiente": ambiente,
        "preie_leistungs_rate": preieLeistungsRate,
        "wartezeit": wartezeit,
        "atmosphare": atmosphare,
      };
}
