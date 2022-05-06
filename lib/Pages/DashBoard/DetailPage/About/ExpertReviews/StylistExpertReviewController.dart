import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/ResponseModel.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/About/ExpertReviews/StylistExpertReviewModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsModel.dart';

class StylistExpertReviewController extends GetxController {
  var storeId = "";
  var selectedEmployeId = 0.obs;
  // ignore: deprecated_member_use
  var arrExpertReviewObj = List<StylistExpertReviewModel>().obs;

  StoreDetailController _storeDetailController = Get.find();

  // ignore: deprecated_member_use
  var arrServiceExpert = List<OurServiceExpert>().obs;
  var isLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    List<dynamic> arr = Get.arguments;

    storeId = arr.first;
    selectedEmployeId.value = arr.last;
    print(arr);

    arrServiceExpert.value =
        _storeDetailController.storeDetailsObj.value.about.ourServiceExpert;

    getStylistExpertReviewData();
  }

  getStylistExpertReviewData() {
    isLoader.value = true;
    ApiProvider apiProvider = ApiProvider();
    var body = {
      'store_id': storeId,
      'emp_id': selectedEmployeId.value.toString()
    };
    print(body);
    apiProvider.post(ApiUrl.viewreviewbyempid, body).then((value) {
      var responseJson = json.decode(value.body);
      ResponseModel responseModel = ResponseModel.fromJson(responseJson);
      print(responseJson);
      arrExpertReviewObj.clear();
      if (responseModel.responseCode == 1) {
        var getData = responseJson['ResponseData'];
        arrExpertReviewObj.value = StylistExpertReviewModel.getData(getData);
        arrExpertReviewObj.value.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        // ignore: invalid_use_of_protected_member
        print(arrExpertReviewObj.value);
      } else {
        print("${responseModel.responseText}========");
        // ignore: invalid_use_of_protected_member
        arrExpertReviewObj.value.clear();
      }

      isLoader.value = false;
    });
  }
}
