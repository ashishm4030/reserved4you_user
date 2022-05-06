class PendingModel {
  int id;
  int appointmentId;
  int storeId;
  int categoryId;
  int subcategoryId;
  int serviceId;
  String serviceName;
  String storeimage;

  int variantId;
  String price;
  String status;
  int storeEmpId;
  String appoDate;
  String appoTime;
  String isPostponed;
  String cancelReason;
  String createdAt;
  String updatedAt;
  String refundId;
  String note;
  String orderId;
  String serviceImage;
  VariantData variantData;
  int servicePrice;
  String serviceExpert;
  String serviceExpertImgae;
  String storeName;
  String storeAddress;
  String isCancellation;
  String appEndTime;
  String remainingtime = "";
  Map<String, dynamic> isReviewed;

  PendingModel({
    this.id,
    this.appointmentId,
    this.storeId,
    this.categoryId,
    this.subcategoryId,
    this.serviceId,
    this.serviceName,
    this.variantId,
    this.price,
    this.status,
    this.storeEmpId,
    this.appoDate,
    this.appoTime,
    this.isPostponed,
    this.cancelReason,
    this.createdAt,
    this.updatedAt,
    this.refundId,
    this.note,
    this.orderId,
    this.serviceImage,
    this.variantData,
    this.servicePrice,
    this.serviceExpert,
    this.serviceExpertImgae,
    this.storeName,
    this.storeAddress,
    this.appEndTime,
    this.isCancellation,
    this.isReviewed,
  });

  PendingModel.fromJson(Map<String, dynamic> json) {
    print('kjnvkasjfsjhjh');
    print(json['service_id']);
    id = json['id'];
    appointmentId = json['appointment_id'];
    storeId = json['store_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    variantId = json['variant_id'];
    price = json['price'];
    status = json['status'];
    storeEmpId = json['store_emp_id'];
    appoDate = json['appo_date'];
    appoTime = json['appo_time'];
    isPostponed = json['is_postponed'];
    cancelReason = json['cancel_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    refundId = json['refund_id'];
    note = json['note'];
    orderId = json['order_id'];
    serviceImage = json['service_image'];
    variantData = json['variantData'] != null ? new VariantData.fromJson(json['variantData']) : null;
    servicePrice = json['service_price'];
    serviceExpert = json['service_expert'];
    serviceExpertImgae = json['service_expert_imgae'];
    storeName = json['store_name'];
    storeAddress = json['store_address'];
    isCancellation = json['is_cancellation'];
    storeimage = json['store_image'];
    remainingtime = json['remaining_time'] ?? "";
    appEndTime = json['app_end_time'] ?? "";
    isReviewed = json['is_reviewed'] is Map ? json['is_reviewed'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment_id'] = this.appointmentId;
    data['store_id'] = this.storeId;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['variant_id'] = this.variantId;
    data['price'] = this.price;
    data['status'] = this.status;
    data['store_emp_id'] = this.storeEmpId;
    data['appo_date'] = this.appoDate;
    data['appo_time'] = this.appoTime;
    data['is_postponed'] = this.isPostponed;
    data['cancel_reason'] = this.cancelReason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['refund_id'] = this.refundId;
    data['note'] = this.note;
    data['order_id'] = this.orderId;
    data['service_image'] = this.serviceImage;
    if (this.variantData != null) {
      data['variantData'] = this.variantData.toJson();
    }
    data['service_price'] = this.servicePrice;
    data['service_expert'] = this.serviceExpert;
    data['service_expert_imgae'] = this.serviceExpertImgae;
    data['store_name'] = this.storeName;
    data['store_address'] = this.storeAddress;
    data['app_end_time'] = this.appEndTime;
    data['is_cancellation'] = this.isCancellation;
    data['is_reviewed'] = this.isReviewed;
    return data;
  }

  static List<PendingModel> getData(dynamic arrData) {
    List<PendingModel> arrTemp = [];

    arrData.forEach((v) {
      arrTemp.add(new PendingModel.fromJson(v));
    });

    return arrTemp;
  }
}

class VariantData {
  int id;
  int storeId;
  int serviceId;
  String description;
  String durationOfService;
  String price;

  VariantData({this.id, this.storeId, this.serviceId, this.description, this.durationOfService, this.price});

  VariantData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    serviceId = json['service_id'];
    description = json['description'];
    durationOfService = json['duration_of_service'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['service_id'] = this.serviceId;
    data['description'] = this.description;
    data['duration_of_service'] = this.durationOfService;
    data['price'] = this.price;
    return data;
  }
}
