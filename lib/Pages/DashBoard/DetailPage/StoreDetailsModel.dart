import 'package:get/get.dart';

class StoreDetails {
  int id;
  int userId;
  String storeName;
  String storeDescription;
  String storeProfile;
  String storeBanner;
  String storeStatus;
  String storeAddress;
  String storeStartTime;
  String storeEndTime;
  String latitude;
  String longitude;
  String paymentMethod;
  String storeActivePlan;
  String storeLinkId;
  String avgRating;
  int totalFeedback;
  List<String> serviceName;
  String categoryName = "";
  var favourite = false.obs;
  bool feedbackFlag;
  About about;
  String storeBannerImagePath = "";
  String storeProfileImagePath;
  List<StoreGalleryPortfolio> storeGallery = [];
  List<StoreGalleryPortfolio> storeGalleryOriginel = [];
  StoreDetails({
    this.id,
    this.userId,
    this.storeName,
    this.storeDescription,
    this.storeProfile,
    this.storeBanner,
    this.storeStatus,
    this.storeAddress,
    this.storeStartTime,
    this.storeEndTime,
    this.latitude,
    this.longitude,
    this.paymentMethod,
    this.storeActivePlan,
    this.storeLinkId,
    this.avgRating,
    this.totalFeedback,
    this.serviceName,
    this.categoryName,
    this.favourite,
    this.feedbackFlag,
    this.about,
    this.storeBannerImagePath,
    this.storeProfileImagePath,
    this.storeGallery,
  });

  StoreDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeName = json['store_name'];
    storeDescription = json['store_description'];
    storeProfile = json['store_profile'];
    storeBanner = json['store_banner'];
    storeStatus = json['store_status'];
    storeAddress = json['store_address'];
    storeStartTime = json['store_start_time'];
    storeEndTime = json['store_end_time'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    paymentMethod = json['payment_method'];
    storeActivePlan = json['store_active_plan'];
    storeLinkId = json['store_link_id'];
    avgRating = json['avg_rating'];
    totalFeedback = json['total_feedback'];
    serviceName = json['serviceName'].cast<String>();
    categoryName = json['categoryName'] ?? "";
    favourite.value = json['favourite'];
    feedbackFlag = json['feedback_flag'];
    about = json['About'] != null ? new About.fromJson(json['About']) : null;
    storeBannerImagePath = json['store_banner_image_path'];
    storeProfileImagePath = json['store_profile_image_path'];
    if (json['store_gallery'] != null) {
      json['store_gallery'].forEach((v) {
        storeGallery.add(new StoreGalleryPortfolio.fromJson(v));
      });
    }

    var obj = StoreGalleryPortfolio();
    obj.storeGalleryImagePath = storeBannerImagePath;
    storeGallery.add(obj);
    if (json['store_gallery'] != null) {
      json['store_gallery'].forEach((v) {
        storeGalleryOriginel.add(new StoreGalleryPortfolio.fromJson(v));
      });
    }
    // if (json['service_details'] != null) {
    //   json['service_details'].forEach((v) {
    //     serviceDetails.add(new ServiceDetails.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_name'] = this.storeName;
    data['store_description'] = this.storeDescription;
    data['store_profile'] = this.storeProfile;
    data['store_banner'] = this.storeBanner;
    data['store_status'] = this.storeStatus;
    data['store_address'] = this.storeAddress;
    data['store_start_time'] = this.storeStartTime;
    data['store_end_time'] = this.storeEndTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['payment_method'] = this.paymentMethod;
    data['store_active_plan'] = this.storeActivePlan;
    data['store_link_id'] = this.storeLinkId;
    data['avg_rating'] = this.avgRating;
    data['total_feedback'] = this.totalFeedback;
    data['serviceName'] = this.serviceName;
    data['categoryName'] = this.categoryName;
    data['favourite'] = this.favourite;
    data['feedback_flag'] = this.feedbackFlag;
    if (this.about != null) {
      data['About'] = this.about.toJson();
    }
    data['store_banner_image_path'] = this.storeBannerImagePath;
    data['store_profile_image_path'] = this.storeProfileImagePath;
    if (this.storeGallery != null) {
      data['store_gallery'] = this.storeGallery.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class About {
  List<Specifics> specifics = [];
  String smallDiscribe;
  List<Advantages> advantages = [];
  List<OurServiceExpert> ourServiceExpert = [];
  String latitude;
  String longitude;
  String district = "-";
  List<PublicTransportation> publicTransportation = [];
  List<OpeningHours> openingHours = [];
  String homeUrl;
  List<Diraction> diraction = [];
  String phoneNumber;
  String locationbymap;
  About(
      {this.specifics,
      this.smallDiscribe,
      this.advantages,
      this.ourServiceExpert,
      this.latitude,
      this.longitude,
      this.district,
      this.publicTransportation,
      this.openingHours,
      this.homeUrl,
      this.diraction,
      this.phoneNumber,
      this.locationbymap});
  About.fromJson(Map<String, dynamic> json) {
    if (json['Specifics'] != null) {
      json['Specifics'].forEach((v) {
        specifics.add(new Specifics.fromJson(v));
      });
    }
    smallDiscribe = json['Small Discribe'];
    if (json['advantages'] != null) {
      json['advantages'].forEach((v) {
        advantages.add(new Advantages.fromJson(v));
      });
    }
    if (json['our_service_expert'] != null) {
      json['our_service_expert'].forEach((v) {
        ourServiceExpert.add(new OurServiceExpert.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
    district = json['district'] ?? "-";
    if (json['public_transportation'] != null) {
      json['public_transportation'].forEach((v) {
        publicTransportation.add(new PublicTransportation.fromJson(v));
      });
    }
    if (json['opening_hours'] != null) {
      json['opening_hours'].forEach((v) {
        openingHours.add(new OpeningHours.fromJson(v));
      });
    }
    homeUrl = json['home_url'];
    locationbymap = json['location_by_map'];
    if (json['diraction'] != null) {
      json['diraction'].forEach((v) {
        diraction.add(new Diraction.fromJson(v));
      });
    }
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specifics != null) {
      data['Specifics'] = this.specifics.map((v) => v.toJson()).toList();
    }
    data['Small Discribe'] = this.smallDiscribe;
    if (this.advantages != null) {
      data['advantages'] = this.advantages.map((v) => v.toJson()).toList();
    }
    if (this.ourServiceExpert != null) {
      data['our_service_expert'] = this.ourServiceExpert.map((v) => v.toJson()).toList();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['district'] = this.district;
    if (this.publicTransportation != null) {
      data['public_transportation'] = this.publicTransportation.map((v) => v.toJson()).toList();
    }
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours.map((v) => v.toJson()).toList();
    }
    data['home_url'] = this.homeUrl;
    if (this.diraction != null) {
      data['diraction'] = this.diraction.map((v) => v.toJson()).toList();
    }
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class Specifics {
  int id;
  int storeId;
  int featureId;
  String name;
  String image;
  String specificsImagePath;

  Specifics({this.id, this.storeId, this.featureId, this.name, this.image, this.specificsImagePath});

  Specifics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    featureId = json['feature_id'];
    name = json['name'];
    image = json['image'];
    specificsImagePath = json['specifics_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['feature_id'] = this.featureId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['specifics_image_path'] = this.specificsImagePath;
    return data;
  }
}

class Advantages {
  int id;
  int storeId;
  String title;
  String description;
  String image;
  String status;
  String createdAt;
  String updatedAt;
  String storeAdvantageImagePath;

  Advantages({this.id, this.storeId, this.title, this.description, this.image, this.status, this.createdAt, this.updatedAt, this.storeAdvantageImagePath});

  Advantages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    storeAdvantageImagePath = json['store_advantage_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['store_advantage_image_path'] = this.storeAdvantageImagePath;
    return data;
  }
}

class OurServiceExpert {
  int id;
  int storeId;
  String empName;
  String status;
  String categoryName;
  String avgRating;
  String avgRatingCount;
  String empImagePath;

  OurServiceExpert({this.id, this.storeId, this.empName, this.status, this.categoryName, this.avgRating, this.avgRatingCount, this.empImagePath});

  OurServiceExpert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    empName = json['emp_name'];
    status = json['status'];
    categoryName = json['category_name'];
    avgRating = json['avg_rating'];
    avgRatingCount = json['avg_rating_count'];
    empImagePath = json['emp_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['emp_name'] = this.empName;
    data['status'] = this.status;
    data['category_name'] = this.categoryName;
    data['avg_rating'] = this.avgRating;
    data['avg_rating_count'] = this.avgRatingCount;
    data['emp_image_path'] = this.empImagePath;
    return data;
  }
}

class PublicTransportation {
  int id;
  int storeId;
  String title;
  String transportationNo;
  String image;
  String status;
  String createdAt;
  String updatedAt;
  String transportationImagePath;

  PublicTransportation({this.id, this.storeId, this.title, this.transportationNo, this.image, this.status, this.createdAt, this.updatedAt, this.transportationImagePath});

  PublicTransportation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    title = json['title'];
    transportationNo = json['transportation_no'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    transportationImagePath = json['transportation_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['title'] = this.title;
    data['transportation_no'] = this.transportationNo;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['transportation_image_path'] = this.transportationImagePath;
    return data;
  }
}

class OpeningHours {
  int id;
  int storeId;
  String day;
  String startTime;
  String endTime;
  String isOff;

  OpeningHours({this.id, this.storeId, this.day, this.startTime, this.endTime, this.isOff});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    day = json['day'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isOff = json['is_off'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['day'] = this.day;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_off'] = this.isOff;
    return data;
  }
}

class Diraction {
  int id;
  int storeId;
  String parkingName;
  String status;
  String createdAt;
  String updatedAt;

  Diraction({this.id, this.storeId, this.parkingName, this.status, this.createdAt, this.updatedAt});

  Diraction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    parkingName = json['parking_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['parking_name'] = this.parkingName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class StoreGalleryPortfolio {
  int id;
  int storeId;
  String file;
  String fileType;
  String createdAt;
  String updatedAt;
  String storeGalleryImagePath;

  StoreGalleryPortfolio({this.id, this.storeId, this.file, this.fileType, this.createdAt, this.updatedAt, this.storeGalleryImagePath});

  StoreGalleryPortfolio.fromJson(Map<String, dynamic> json) {
    storeGalleryImagePath = json['store_gallery_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['file'] = this.file;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['store_gallery_image_path'] = this.storeGalleryImagePath;
    return data;
  }
}

class ServiceDetails {
  int id;
  int storeId;
  String categoryId;
  int subcategoryId;
  String serviceName;
  String price;
  String startTime;
  String endTime;
  String startDate;
  String endDate;
  String discountType;
  String discount;
  String durationofservice = "";
  String image;
  String isPopular;
  String finalPrice;
  String serviceImagePath;
  SubCategoryData subCategoryData;
  List<ServiceVariant> serviceVariant = [];
  var isvarientMenuOpen = false.obs;
  var isvarientMenuOpenForAllService = false.obs;
  var fromPrice = "0.00";
  var dureationOfServiceNew = "";

  ServiceDetails({
    this.id,
    this.storeId,
    this.categoryId,
    this.subcategoryId,
    this.serviceName,
    this.price,
    this.startTime,
    this.endTime,
    this.startDate,
    this.endDate,
    this.discountType,
    this.discount,
    this.image,
    this.isPopular,
    this.finalPrice,
    this.serviceImagePath,
    this.subCategoryData,
    this.serviceVariant,
    this.durationofservice,
  });

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    serviceName = json['service_name'];
    price = json['price'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    discountType = json['discount_type'];
    discount = json['discount'].toString() ?? "";
    image = json['image'];
    isPopular = json['is_popular'];
    finalPrice = json['finalPrice'];
    serviceImagePath = json['service_image_path'];
    durationofservice = json['duration_of_service'] ?? "";
    subCategoryData = json['sub_category_data'] != null ? new SubCategoryData.fromJson(json['sub_category_data']) : null;
    if (json['service_variant'] != null) {
      json['service_variant'].forEach((v) {
        serviceVariant.add(new ServiceVariant.fromJson(v));
      });
    }

    var obj = serviceVariant.reduce((value, element) => double.parse(value.finalPriceVariant) < double.parse(element.finalPriceVariant) ? value : element);
    fromPrice = obj.finalPriceVariant;

    var minService = serviceVariant.reduce((value, element) => double.parse(value.durationOfService) < double.parse(element.durationOfService) ? value : element);

    var maxService = serviceVariant.reduce((value, element) => double.parse(value.durationOfService) > double.parse(element.durationOfService) ? value : element);

    if (serviceVariant.length > 1) {
      dureationOfServiceNew = minService.durationOfService + " min" + " - " + maxService.durationOfService + " min";
    } else {
      dureationOfServiceNew = minService.durationOfService + " min";
    }
  }

  static List<ServiceDetails> getData(dynamic arrData) {
    List<ServiceDetails> arrTemp = [];

    arrData.forEach((v) {
      arrTemp.add(new ServiceDetails.fromJson(v));
    });

    return arrTemp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['discount_type'] = this.discountType;
    data['discount'] = this.discount;
    data['image'] = this.image;
    data['is_popular'] = this.isPopular;
    data['finalPrice'] = this.finalPrice;
    data['service_image_path'] = this.serviceImagePath;
    if (this.subCategoryData != null) {
      data['sub_category_data'] = this.subCategoryData.toJson();
    }
    if (this.serviceVariant != null) {
      data['service_variant'] = this.serviceVariant.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryData {
  int id;
  int mainCategory;
  String name;
  String image;
  String categoryImagePath;

  SubCategoryData({this.id, this.mainCategory, this.name, this.image, this.categoryImagePath});

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainCategory = json['main_category'];
    name = json['name'];
    image = json['image'];
    categoryImagePath = json['category_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_category'] = this.mainCategory;
    data['name'] = this.name;
    data['image'] = this.image;
    data['category_image_path'] = this.categoryImagePath;
    return data;
  }
}

class ServiceVariant {
  int id;
  int storeId;
  int serviceId;
  String description;
  String durationOfService;
  String minDuration;
  String maxDuration;
  String price;
  String createdAt;
  String updatedAt;
  String finalPriceVariant;
  var tempselectflag = false.obs;
  ServiceVariant({
    this.id,
    this.storeId,
    this.serviceId,
    this.description,
    this.durationOfService,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.tempselectflag,
    this.maxDuration,
    this.minDuration,
    this.finalPriceVariant,
  });

  ServiceVariant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    serviceId = json['service_id'];
    description = json['description'];
    durationOfService = json['duration_of_service'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    finalPriceVariant = json['finalPriceVariant'];
    minDuration = json['min_duration'];
    maxDuration = json['max_duration'];

    tempselectflag.value = json['temp_select_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['service_id'] = this.serviceId;
    data['description'] = this.description;
    data['duration_of_service'] = this.durationOfService;
    data['min_duration'] = this.minDuration;
    data['max_duration'] = this.maxDuration;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ParticularServiceDetails {
  int id;
  String serviceName;
  String description;
  String image;
  String avgRating;
  String avgRatingCount;
  String serviceImagePath;

  ParticularServiceDetails({this.id, this.serviceName, this.description, this.image, this.avgRating, this.avgRatingCount, this.serviceImagePath});

  ParticularServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    description = json['description'];
    image = json['image'];
    avgRating = json['avg_rating'];
    avgRatingCount = json['avg_rating_count'];
    serviceImagePath = json['service_image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['description'] = this.description;
    data['image'] = this.image;
    data['avg_rating'] = this.avgRating;
    data['avg_rating_count'] = this.avgRatingCount;
    data['service_image_path'] = this.serviceImagePath;
    return data;
  }
}
