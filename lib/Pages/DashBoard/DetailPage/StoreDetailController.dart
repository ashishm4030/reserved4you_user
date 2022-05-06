import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/ResponseModel.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/commanFuncation.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/ReviewModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsModel.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/SelectedServiceModel.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:reserve_for_you_user/Pages/Profile/Profiile_Model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DashBoardController.dart';
import '../DashBoardModel.dart';

class StoreDetailController extends GetxController {
  BuildContext context;
  var arrStoreGalleryStr = <String>[].obs;
  var sortText = 'sort'.tr.obs;
  var selectedSubCategoryForReviewInd = "".obs;
  var ratingForFilterReview = "0.0".obs;
  var fabIconNumber = false.obs;
  var selectedStoreId = "";

  var maxLine = false.obs;
  var storeDetailsObj = StoreDetails().obs;
  var storeReviewObj = ReviewModel().obs;
  var isLoader = true.obs;
  var markers = Set<Marker>().obs;
  var weekday = "";
  var currentTimeStlot = "";
  var currentWeekDayObj = OpeningHours();
  var txtStylistSearch = TextEditingController();
  ScrollController scrollController = ScrollController();
  var selectedtabIndex = 0.obs;
  var selectedRating = false.obs;
  var starIcon = false.obs;
  var userDataObj = User().obs;

  var selectedIndex = 0.obs;
  var selectedfilterForReview = 0.obs;

  var selectedCategoryId = 0.obs;
  var selectedSubCategoryId = "".obs;
  var selectedSubCategoryName = 'subCategories'.tr.obs;

  // ignore: deprecated_member_use
  var arrCategoryWiseSubCategory = List<CategoryWiseSubCategory>().obs;

  // ignore: deprecated_member_use
  var arrTopDiscountAndPopluar = List<ServiceDetails>().obs;

  // ignore: deprecated_member_use
  var arrAllServices = List<ServiceDetails>().obs;

  //var arrSortByReview = List<ReviewModel>().obs;
  // ignore: deprecated_member_use
  var arrCategoryWiseSubCategoryReview = List<CategoryWiseSubCategory>().obs;

  var totalSelectetServicePrice = 0.00.obs;
  var totalSelectedServicesCount = 0.obs;
  var deviceId;
  var revierTextEditing = TextEditingController();
  var isOpenForService = true.obs;
  bool isHome = false;
  bool scrollFirstTime = false;
  String commentId = '';
  var type = "";
  var reviewButtonText = 'giveFeedBack'.tr.obs;
  PageController pageController = PageController(initialPage: 0);

  List<String> _weekList = [
    'sun'.tr,
    'mon'.tr,
    'tues'.tr,
    'wed'.tr,
    'thurs'.tr,
    'fri'.tr,
    'sat'.tr,
    'sun'.tr,
  ];
  List<String> weekListInEnglish = [
    "Sun",
    "Mon", //--
    "Tues", //--
    "Wed", //--
    "Thurs", //--
    "Fri", //--
    "Sat", //--
    "Sun",
  ];

  @override
  void onInit() async {
    super.onInit();

    await CommonVariables(context: context).getId().then((value) {
      deviceId = value;
    });

    getAllProfileData();
    if (Get.arguments is Map) {
      selectedStoreId = Get.arguments['storeId'];
      isHome = true;
      commentId = Get.arguments['id'];
      selectedtabIndex.value = 3;
      type = Get.arguments['type'].toString();
    } else {
      selectedStoreId = Get.arguments;
      isHome = false;
    }

    weekday = _weekList[DateTime.now().weekday];
    getStoreDetails();

    getAllCategoryData();

    revierTextEditing = TextEditingController();
    getReviewData();

    getSelectedServiceDataToServer();
    getAllProfileData();
  }

  void onScrollJump() {
    Future.delayed(Duration.zero, () {
      int index = -1;
      bool flag = false;
      for (int i = 0; i < storeReviewObj.value.customerReview.length; i++) {
        index++;
        if (storeReviewObj.value.customerReview[i].id.toString() == commentId) {
          flag = true;
          break;
        }
      }
      // ignore: unnecessary_statements
      flag ? scrollController.jumpTo(1250 + (index * 240).toDouble()) : scrollController.jumpTo(1250);
    });
  }

  @override
  void onClose() {
    super.onClose();
    if (totalSelectedServicesCount.value != 0) {
      clearParticularStoreSelection();
    }
  }

  var arrCategory = <ServiceWiseAllCategory>[].obs;

  void getAllCategoryData() {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      'store_id': selectedStoreId,
    };

    apiProvider.post(ApiUrl.storewisecategory, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);

      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrCategory.value = ServiceWiseAllCategory.getData(responsedata);
        var currentObj = arrCategory.first;
        selectedCategoryId.value = currentObj.categoryId;
        getCategoryWiseSubCategory();
      } else {}
    });
  }

  Future<void> getAllProfileData() async {
    String userStr = await Preferences.preferences.getString(key: PrefernceKey.userData);

    userDataObj.value = User.fromJson(jsonDecode(userStr));
  }

  void getStoreDetails({String searchtext = ""}) {
    isLoader.value = true;
    ApiProvider apiProvider = ApiProvider();

    var body = {
      'provider_id': selectedStoreId,
      'emp_name_search': searchtext,
    };

    print(body);
    apiProvider.post(ApiUrl.getserviceproviderlist, body).then((value) {
      var responseJson = json.decode(value.body);

      print(responseJson);
      String currentDay = weekListInEnglish[DateTime.now().weekday];
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        storeDetailsObj.value = StoreDetails.fromJson(responsedata);
        isLoader.value = false;
        currentWeekDayObj = storeDetailsObj.value.about.openingHours.firstWhere((element) {
          return element.day.toUpperCase().contains(currentDay.toUpperCase());
        });

        arrStoreGalleryStr.clear();

        for (StoreGalleryPortfolio temp in storeDetailsObj.value.storeGallery) {
          arrStoreGalleryStr.add(temp.storeGalleryImagePath);
        }

        currentTimeStlot = "(${currentWeekDayObj.startTime} - ${currentWeekDayObj.endTime})";
        markers.add(Marker(
          markerId: MarkerId("xcvxcv"),
          onTap: () {
            openGoogelMap();
          },
          infoWindow: InfoWindow(title: storeDetailsObj.value.storeName, snippet: storeDetailsObj.value.storeAddress),
          position: LatLng(double.parse(storeDetailsObj.value.about.latitude), double.parse(storeDetailsObj.value.about.longitude)),
        ));
      } else {}

      isLoader.value = false;
    });
  }

  void openGoogleMap() async {
    double lat = double.parse(storeDetailsObj.value.latitude);
    double long = double.parse(storeDetailsObj.value.longitude);
    print("late = $lat");
    print("long = $long");
    if (lat != null && long != null) {
      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      print(googleUrl);
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    } else {
      showTostMessage(message: "Could not launch on this location");
    }
  }

  clearFilter() {
    ratingForFilterReview.value = 0.0.toString();
    selectedfilterForReview.value = 0;
    selectedSubCategoryForReviewInd.value = "0.0";
    arrCategoryWiseSubCategoryReview..clear();
  }

  void getSearchData({String searchtext = ""}) {
    ApiProvider apiProvider = ApiProvider();
    var body = {
      'provider_id': selectedStoreId,
      'emp_name_search': searchtext,
    };
    print(body);
    apiProvider.post(ApiUrl.getserviceproviderlist, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        storeDetailsObj.value = StoreDetails.fromJson(responsedata);
      } else {}
    });
  }

  void getCategoryWiseSubCategory() {
    ApiProvider apiProvider = ApiProvider();
    selectedSubCategoryId.value = "";
    //selectedSubCategoryName.value = "Sub-categories";
    var body = {
      "category_id": selectedCategoryId.value.toString(),
      "store_id": selectedStoreId,
    };
    print(body);
    selectedSubCategoryName.value = '';
    apiProvider.post(ApiUrl.catewisesubcategory, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrCategoryWiseSubCategory.value = CategoryWiseSubCategory.getData(responsedata);
        selectedSubCategoryId.value = arrCategoryWiseSubCategory.first.id.toString();

        selectedSubCategoryName.value = arrCategoryWiseSubCategory.first.name;
        getServiceAccrdingtoCatSubCat();
      } else {}
    });
  }

  void getSelectedServiceDataToServer() {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      "device_token": deviceId,
    };
    print(body);
    apiProvider.post(ApiUrl.getselectservice, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      totalSelectetServicePrice.value = 0.00;
      print(_responseModel.toJson());
      totalSelectedServicesCount.value = 0;
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        // ignore: unused_local_variable
        var arrSelectedServices = SelectedServiceModel.getData(responsedata);

        for (SelectedServiceModel obj in arrSelectedServices) {
          for (Servicecategory temp in obj.servicecategory) {
            for (SelectedServiceVariant vobj in temp.serviceVariant) {
              totalSelectedServicesCount.value += 1;

              totalSelectetServicePrice.value += double.parse(removeComma(vobj.vpricefinal));
            }
          }
        }
        // isLoader.value = false;
        isOpenForService.value = false;
      } else {}
    });
  }

  void getServiceAccrdingtoCatSubCat() {
    ApiProvider apiProvider = ApiProvider();
    var body = {
      "store_id": selectedStoreId,
      "category_id": selectedCategoryId.value.toString(),
      "subcategory_id": selectedSubCategoryId.value,
      "device_id": deviceId,
    };
    print(body);
    apiProvider.post(ApiUrl.catesubcateservice, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);

      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];

        var arrServices = ServiceDetails.getData(responsedata);
        arrTopDiscountAndPopluar.clear();
        arrAllServices.clear();
        arrAllServices.addAll(arrServices);

        for (ServiceDetails obj in arrServices) {
          if (obj.isPopular == "yes") {
            arrTopDiscountAndPopluar.add(obj);
          }
        }
      } else {}
    });
  }

  void getparticularSergviceDescription({String serviceid}) {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      "service_id": serviceid,
      "store_id": selectedStoreId,
    };
    print(body);
    apiProvider.post(ApiUrl.showservicedetails, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];

        var obj = ParticularServiceDetails.fromJson(responsedata);

        Get.toNamed("/showDetailsView", arguments: obj);
      } else {}
    });
  }

  void clickToOpenVarientDialogFromDiscountPopuler({int selectedIndex, bool isForAllService}) {
    if (isForAllService) {
      arrAllServices[selectedIndex].isvarientMenuOpenForAllService.value = !arrAllServices[selectedIndex].isvarientMenuOpenForAllService.value;
    } else {
      arrTopDiscountAndPopluar[selectedIndex].isvarientMenuOpen.value = !arrTopDiscountAndPopluar[selectedIndex].isvarientMenuOpen.value;
    }
  }

  void clickToSelectServiceWithoutVarient({int selectedIndex, bool isForAllService}) {
    var serviceId = "";
    var varientId = "";
    var isSelected = false;

    if (isForAllService) {
      arrAllServices[selectedIndex].serviceVariant.first.tempselectflag.value = !arrAllServices[selectedIndex].serviceVariant.first.tempselectflag.value;

      isSelected = arrAllServices[selectedIndex].serviceVariant.first.tempselectflag.value;

      serviceId = arrAllServices[selectedIndex].id.toString();
      varientId = arrAllServices[selectedIndex].serviceVariant.first.id.toString();
    } else {
      arrTopDiscountAndPopluar[selectedIndex].serviceVariant.first.tempselectflag.value = !arrTopDiscountAndPopluar[selectedIndex].serviceVariant.first.tempselectflag.value;
      isSelected = arrTopDiscountAndPopluar[selectedIndex].serviceVariant.first.tempselectflag.value;
      serviceId = arrTopDiscountAndPopluar[selectedIndex].id.toString();
      varientId = arrTopDiscountAndPopluar[selectedIndex].serviceVariant.first.id.toString();
    }

    callApiForSelectedCancelService(serviceid: serviceId, servicevariantid: varientId, isSelected: isSelected);
  }

//nirupa
  void clickToSelectServiceWithVarient({int selectedIndex, bool isForAllService, int selectedVarientInd}) {
    var serviceId = "";
    var varientId = "";
    var isSelected = false;
    //isLoader.value = true;

    if (isForAllService) {
      var currentObj = arrAllServices[selectedIndex].serviceVariant[selectedVarientInd];

      for (ServiceDetails obj in arrAllServices) {
        if (arrAllServices[selectedIndex].id == obj.id) {
          for (ServiceVariant vObj in obj.serviceVariant) {
            if (vObj.id != currentObj.id) {
              vObj.tempselectflag.value = false;
            }
          }
        }
      }
      currentObj.tempselectflag.value = !currentObj.tempselectflag.value;

      isSelected = currentObj.tempselectflag.value;

      serviceId = arrAllServices[selectedIndex].id.toString();
      varientId = currentObj.id.toString();
    } else {
      var currentObj = arrTopDiscountAndPopluar[selectedIndex].serviceVariant[selectedVarientInd];

      for (ServiceDetails obj in arrTopDiscountAndPopluar) {
        for (ServiceVariant vObj in obj.serviceVariant) {
          if (vObj.id != currentObj.id) {
            vObj.tempselectflag.value = false;
          }
        }
      }

      currentObj.tempselectflag.value = !currentObj.tempselectflag.value;

      serviceId = arrTopDiscountAndPopluar[selectedIndex].id.toString();
      varientId = currentObj.id.toString();
      isSelected = currentObj.tempselectflag.value;
    }
    callApiForSelectedCancelService(serviceid: serviceId, servicevariantid: varientId, isSelected: isSelected);
  }

  void sendSelectedServiceDataToServer({String serviceId, String varientId = "", String id}) {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      "device_token": deviceId,
      "category_id": selectedCategoryId.value.toString(),
      "service_id": serviceId,
      "service_variant_id": varientId,
      "store_id": selectedStoreId,
      "subcategory_id": "",
      "storeDetailsObj": "",
    };
    print(body);
    apiProvider.post(ApiUrl.storeselectservice, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      int id = responseJson["ResponseData"]["id"];
      print(id);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        getSelectedServiceDataToServer();
      } else {}
    });
  }

  void checkIfLoginOrNot() async {
    var isLogin = await Preferences.preferences.getBool(key: PrefernceKey.isUserLogin, defValue: false);

    if (isLogin) {
      // ignore: unrelated_type_equality_checks
      var url = storeDetailsObj.value.favourite == true ? ApiUrl.removestorefavorites : ApiUrl.addstorefavorites;

      doFavouriteFromServer(url);
    } else {
      Get.toNamed("/login", arguments: true);
    }
  }

  void doFavouriteFromServer(String url) {
    ApiProvider apiProvider = ApiProvider();

    var body = {"store_id": selectedStoreId};
    print(body);
    apiProvider.post(url, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        storeDetailsObj.value.favourite.value = !storeDetailsObj.value.favourite.value;
        DashBoardController _dashBoardController = Get.find();
        _dashBoardController.getAllDataForDashboard();
      } else {}
    });
  }

  void callApiForSelectedCancelService({
    String serviceid,
    String servicevariantid,
    bool isSelected,
  }) {
    if (isSelected) {
      sendSelectedServiceDataToServer(serviceId: serviceid, varientId: servicevariantid);
    } else {
      cancelService(servicevariantid: servicevariantid, serviceid: serviceid);
    }
    //calculateTotalPriceAndServics();
  }

  void cancelService({String serviceid, String servicevariantid}) {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      "device_token": deviceId,
      "store_id": selectedStoreId,
      "service_id": serviceid,
      "service_variant_id": servicevariantid,
    };
    print(body);
    apiProvider.post(ApiUrl.storecancelservice, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);

      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        getSelectedServiceDataToServer();
      } else {}

      //showTostMessage(message: _responseModel.responseText);
    });
  }

  void getReviewData({String sorTing = " ", String searchText = ""}) {
    ApiProvider apiProvider = ApiProvider();
    var body = {'store_id': selectedStoreId, 'sorting': sorTing, 'search_text': searchText};
    apiProvider.post(ApiUrl.storeReview, body).then((value) {
      var responseJson = json.decode(value.body);
      ResponseModel responseModel = ResponseModel.fromJson(responseJson);
      if (responseModel.responseCode == 1) {
        var responseData = responseJson["ResponseData"];
        storeReviewObj.value = ReviewModel.fromJson(responseData);
        for (CustomerReview user in storeReviewObj.value.customerReview) {}
      }
    });
  }

  void sortByReviewData({String sorTing = " "}) {
    ApiProvider apiProvider = ApiProvider();
    var body = {
      'store_id': selectedStoreId,
      'sort_by': sorTing,
    };
    apiProvider.post(ApiUrl.sortbyreview, body).then((value) {
      var responseJson = json.decode(value.body);
      ResponseModel responseModel = ResponseModel.fromJson(responseJson);
      if (responseModel.responseCode == 1) {
        var responseData = responseJson["ResponseData"];

        var arr = CustomerReview.getData(responseData);

        storeReviewObj.value.customerReview.clear();
        storeReviewObj.value.customerReview.addAll(arr);

        print(arr.length);
      }

      Get.back();
    });
  }

  void getCategoryWiseSubCategoryReview() {
    ApiProvider apiProvider = ApiProvider();
    isLoader.value = true;

    var body = {
      "category_id": selectedfilterForReview.value.toString(),
      "store_id": selectedStoreId,
    };
    print(body);
    arrCategoryWiseSubCategoryReview.clear();
    apiProvider.post(ApiUrl.catewisesubcategory, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrCategoryWiseSubCategoryReview.value = CategoryWiseSubCategory.getData(responsedata);
        isLoader.value = false;
      } else {
        isLoader.value = false;
      }
    });
  }

  void filterByReviewData() {
    ApiProvider apiProvider = ApiProvider();
    var body = {
      'store_id': selectedStoreId,
      'rating': ratingForFilterReview.value,
      'category_id': selectedfilterForReview.value.toString(),
      'service_id': selectedSubCategoryForReviewInd.value.toString()
    };
    apiProvider.post(ApiUrl.filterbyreview, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      storeReviewObj.value.customerReview.clear();
      ResponseModel responseModel = ResponseModel.fromJson(responseJson);
      if (responseModel.responseCode == 1) {
        var responseData = responseJson["ResponseData"];

        var arr = CustomerReview.getData(responseData);

        storeReviewObj.value.customerReview.addAll(arr);
        print(arr.length);
      }

      Get.back();
    });
  }

  void clearParticularStoreSelection() {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      "store_id": selectedStoreId,
      "device_token": deviceId.toString(),
    };
    print(body);
    apiProvider.post(ApiUrl.clearselectionstore, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
      } else {}
    });
  }

  openGoogelMap() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${storeDetailsObj.value.about.latitude},${storeDetailsObj.value.about.longitude}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  String removeComma(String vpricefinal) {
    return vpricefinal.replaceAll(",", "");
  }
}
