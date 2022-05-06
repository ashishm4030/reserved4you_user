import 'package:get/get.dart';

class StylistExpertReviewModel {
  int id;
  int userId;
  int storeId;
  String serviceRate;
  String ambiente;
  String preieLeistungsRate;
  String wartezeit;
  String atmosphare;
  String writeComment;
  String createdAt;
  String updatedAt;
  String totalAvgRating;
  int serviceId;
  int empId;
  String storeReplay;
  String userImage;
  String userName;
  String empName;
  String dayAgo;
  String serviceName = "";
  var isOpen = false.obs;
  var isOpenReplay = false.obs;
  var noProfilcePicData = "-";
  StylistExpertReviewModel(
      {this.id,
      this.userId,
      this.storeId,
      this.serviceRate,
      this.ambiente,
      this.preieLeistungsRate,
      this.wartezeit,
      this.atmosphare,
      this.writeComment,
      this.createdAt,
      this.updatedAt,
      this.totalAvgRating,
      this.serviceId,
      this.empId,
      this.storeReplay,
      this.userImage,
      this.userName,
      this.empName,
      this.dayAgo,
      this.serviceName});

  StylistExpertReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    serviceRate = json['service_rate'];
    ambiente = json['ambiente'];
    preieLeistungsRate = json['preie_leistungs_rate'];
    wartezeit = json['wartezeit'];
    atmosphare = json['atmosphare'];
    writeComment = json['write_comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalAvgRating = json['total_avg_rating'];
    serviceId = json['service_id'];
    empId = json['emp_id'];
    storeReplay = json['store_replay'];
    userImage = json['user_image'];
    userName = json['user_name'];
    empName = json['emp_name'];
    dayAgo = json['dayAgo'];
    serviceName = json['service_name'] ?? "";

    if (userName == null || userName.trim().isNotEmpty) {
      var arrStr = userName.split(" ");
      if (arrStr.length > 0) {
        var first = arrStr.first.substring(0, 1).toUpperCase();
        var last = arrStr.last.substring(0, 1).toUpperCase();
        noProfilcePicData = first + last;
      }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['service_rate'] = this.serviceRate;
    data['ambiente'] = this.ambiente;
    data['preie_leistungs_rate'] = this.preieLeistungsRate;
    data['wartezeit'] = this.wartezeit;
    data['atmosphare'] = this.atmosphare;
    data['write_comment'] = this.writeComment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_avg_rating'] = this.totalAvgRating;
    data['service_id'] = this.serviceId;
    data['emp_id'] = this.empId;
    data['store_replay'] = this.storeReplay;
    data['user_image'] = this.userImage;
    data['user_name'] = this.userName;
    data['emp_name'] = this.empName;
    data['dayAgo'] = this.dayAgo;
    data['service_name'] = this.serviceName;
    return data;
  }

  static List<StylistExpertReviewModel> getData(dynamic arrData) {
    List<StylistExpertReviewModel> arrTemp = [];

    arrData.forEach((v) {
      arrTemp.add(new StylistExpertReviewModel.fromJson(v));
    });

    return arrTemp;
  }
}
