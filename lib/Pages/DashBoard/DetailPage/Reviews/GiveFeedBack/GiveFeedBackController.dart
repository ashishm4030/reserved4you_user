import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/ResponseModel.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/GiveFeedBack/AllServiceDetailsModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/SelectedServiceModel.dart';

class GiveFeedBackController extends GetxController {
  var selectedStoreId = "";
  var arrAvailbleEmplloyee = <ServiceViseEmploye>[].obs;
  var selecedIndexForEmp = "".obs;
  var arrCategory = <ServiceWiseAllCategory>[].obs;
  var servicerate = "0".obs;
  var ambiente = "0".obs;
  var preieleistungsrate = "0".obs;
  var wartezeit = "0".obs;
  var atmosphare = "0".obs;
  var selectedEmployeeName = 'selectEmployee'.tr.obs;
  var selectedServiceName = 'selectServices'.tr.obs;
  var selectedStoreName = "";
  var selectedStoreImage = "";
  var selectedCategoryId = "".obs;
  var arrAllServiceData = <AllServiceData>[].obs;
  var selectedSubCategoryId = "".obs;
  var selectedSubCategoryWiseServiceID = "".obs;
  var txtTypeYourExep = TextEditingController();
  var arrSearchService = <AllServiceServiceSubcategory>[].obs;
  var isSearchServicepen = false.obs;
  var isFromStoreDetails = false;
  var empId = "";
  var appointmentIOd = "".obs;

  @override
  void onInit() {
    super.onInit();
    List<dynamic> arr = Get.arguments;
    isFromStoreDetails = arr.last;
    print("arr-result$arr");

    selectedStoreId = arr.first.toString();
    selectedStoreName = arr[1].toString();
    selectedStoreImage = arr[2].toString();
    if (!isFromStoreDetails) {
      selectedSubCategoryWiseServiceID.value = arr[3].toString();
      selectedServiceName.value = arr[4].toString();
      selectedEmployeeName.value = arr[5];
      empId = arr[6].toString();
      selectedCategoryId.value = arr[7].toString();
      selectedSubCategoryId.value = arr[8].toString();
      appointmentIOd.value = arr[9].toString();
    }

    getAllCategoryData();
    getEmployeesFromServer("");
  }

  void getEmployeesFromServer(String searchText) async {
    ApiProvider apiProvider = ApiProvider();

    await apiProvider.post(ApiUrl.storeemployee, {'store_id': selectedStoreId, 'search_by_name': searchText}).then(
      (value) {
        var responseJson = json.decode(value.body);
        print(responseJson);
        // ignore: invalid_use_of_protected_member
        arrAvailbleEmplloyee.value.clear();
        ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
        if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
          var responsedata = responseJson["ResponseData"];
          arrAvailbleEmplloyee.value = ServiceViseEmploye.getData(responsedata);
        }
      },
    );
  }

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
        if (!isFromStoreDetails) {
          getAllServiceDataAccrodingCat();
        }
      } else {}
    });
  }

  void validateReview() {
    if (txtTypeYourExep.text.isEmpty) {
      showTostMessage(message: 'writeCommentBelow'.tr);
    } else {
      giveFeedBack();
    }
  }

  void giveFeedBack() async {
    ApiProvider apiProvider = ApiProvider();

    if (selecedIndexForEmp.value.isNotEmpty) {
      empId = arrAvailbleEmplloyee[int.parse(selecedIndexForEmp.value)].id.toString();
    }

    var body = {
      'store_id': selectedStoreId,
      'category_id': selectedCategoryId.value.toString(),
      'subcategory_id': selectedSubCategoryId.value.toString(),
      'service_id': selectedSubCategoryWiseServiceID.value.toString(),
      'emp_id': empId,
      'service_rate': servicerate.value.toString(),
      'ambiente': ambiente.value.toString(),
      'preie_leistungs_rate': preieleistungsrate.value.toString(),
      'wartezeit': wartezeit.value.toString(),
      'atmosphare': atmosphare.value.toString(),
      'write_comment': txtTypeYourExep.text,
      'id': appointmentIOd.value.toString(),
    };

    print(body);
    await apiProvider.post(ApiUrl.userstorerating, body).then(
      (value) {
        var responseJson = json.decode(value.body);
        print(responseJson);
        ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
        if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
          showTostMessage(message: "ratingSubmitedSuccessfully".tr);
          if (isFromStoreDetails) {
            StoreDetailController controller = Get.put(StoreDetailController());
            controller.getReviewData();
          }
          Get.back();
        }
      },
    );
  }

  void getAllServiceDataAccrodingCat() async {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      'store_id': selectedStoreId,
      'category_id': selectedCategoryId.value.toString(),
    };
    await apiProvider.post(ApiUrl.getsubcateservice, body).then(
      (value) {
        var responseJson = json.decode(value.body);
        print(responseJson);

        ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
        if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
          var responsedata = responseJson["ResponseData"];
          arrAllServiceData.value = AllServiceData.getData(responsedata);
        }
      },
    );
  }

  void getAllServiceFromSearch(String searchtext) async {
    ApiProvider apiProvider = ApiProvider();

    var body = {
      'store_id': selectedStoreId,
      'search_by_name': searchtext,
    };
    await apiProvider.post(ApiUrl.storeservicesearch, body).then(
      (value) {
        var responseJson = json.decode(value.body);
        print(responseJson);

        ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
        // ignore: invalid_use_of_protected_member
        arrSearchService.value.clear();
        if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
          var responsedata = responseJson["ResponseData"];
          arrSearchService.value = AllServiceServiceSubcategory.getData(responsedata);
          isSearchServicepen.value = true;
        } else {
          var responsedata = [];
          arrSearchService.value = AllServiceServiceSubcategory.getData(responsedata);
          isSearchServicepen.value = false;
        }
      },
    );
  }
}
