import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/ResponseModel.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/commanFuncation.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/Authentication/Login/LoginModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardModel.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {
  var refreshController = RefreshController();
  var scrollController = ScrollController();
  var arrCategory = <CatgoryData>[].obs;
  var arrRecommandedBestRated = <TopRatedStore>[].obs;
  var arrStoreList = <StoreList>[].obs;
  var arrSpecifics = <FliterSpecifics>[].obs;
  var selectedIndex = "".obs;
  var title = "".obs;
  var isLoader = false.obs;
  var mainCategorySelected = "";
  var selectedCategoryId = "".obs;
  var selectedCategoryName = 'all'.tr.obs;
  var selectedOptions = "new";
  var selectedOptionsInd = 0.obs;
  var isBookingSystem = true.obs;
  var isDiscount = false.obs;
  var sortByText = 'sort'.tr.obs;
  var selectedRating = "0".obs;
  var selectedPrice = "0".obs;
  var selectedIds = [].obs;
  var selectedDate = 'whichDate'.tr.obs;
  var fabIconNumber = false.obs;

  // ignore: deprecated_member_use
  var arrCategoryWiseSubCategory = List<CategoryWiseSubCategory>().obs;

  // ignore: deprecated_member_use
  var arrCategoryWiseSubCategoryString = List<String>().obs;

  // ignore: deprecated_member_use
  var arrStoreSuggestionString = List<SuggestionData>().obs;
  var isSuggestionPopUpOpen = false.obs;
  var selectedSuggestionObj = SuggestionData().obs;
  var pincode = "";

  //selected area
  var selectedAddress = 'postCodeOrArea'.tr.obs;
  var selectedAddressForFilter = "Find by place,name and,zip code..".obs;
  var markers = Set<Marker>().obs;
  var selectedLat = 51.1657.obs;
  var selectedLon = 10.4515.obs;
  var currentDate = DateTime.now().obs;
  var formatedDate = ''.obs;
  var isDateSelected = false.obs;
  var selectedStoreId = "";
  var selectedSubCategoryId = "".obs;
  var selectedSubCategoryName = 'subCategorys'.tr.obs;
  var pincodeForSearch = "";
  var suggestionStr = TextEditingController().obs;
  var deviceId = "";
  var isScroll = false.obs;
  var currentSuggetionTab = "Store".obs;

  //index
  BuildContext context;
  var markersForMapView = Set<Marker>().obs;
  var myFocusNode = FocusNode();

  CameraPosition cameraPositionForMapView = CameraPosition(
    target: LatLng(51.1657, 10.4515),
    zoom: 20,
  );

  @override
  // ignore: must_call_super
  void onInit() async {
    refreshController = RefreshController();
    scrollController = ScrollController();
    sortByText = 'sort'.tr.obs;

    myFocusNode = FocusNode();
    var isLogin = await Preferences.preferences
        .getBool(key: PrefernceKey.isUserLogin, defValue: false);

    if (isLogin) {
      var userData =
          await Preferences.preferences.getString(key: PrefernceKey.userData);

      var loginUserDataObj = LoginModel.fromJson(jsonDecode(userData));
      title.value = 'hi'.tr + " " + loginUserDataObj.firstName;
    } else {
      title.value = 'welcom'.tr;
    }

    mainCategorySelected = await Preferences.preferences
        .getString(key: PrefernceKey.mainSelectedCategory);
    getAllCategoryData();
    getAllDataForDashboard();
    getSpecificationForFilter();

    await CommonVariables(context: context).getId().then((value) {
      deviceId = value;
      clearParticularStoreSelection();
    });
  }

  onSuggetionStoreTap() {
    currentSuggetionTab.value = "Store";
    arrStoreSuggestionString.value = [];
    getSuggestions(searchtext: suggestionStr.value.text);
  }

  onSuggetionServiceTap() {
    currentSuggetionTab.value = "Services";
    arrStoreSuggestionString.value = [];
    getSuggestions(searchtext: suggestionStr.value.text);
  }

  void getAllCategoryData() {
    isLoader.value = true;
    ApiProvider apiProvider = ApiProvider();

    apiProvider.getApiCall(ApiUrl.allCategory).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrCategory.value = CatgoryData.getData(responsedata);

        print(arrCategory.length);
        getCategoryWiseSubCategory();
        getAllDataForDashboard();
      } else {
        isLoader.value = false;
      }
    });
  }

  void getAllDataForDashboard() {
    ApiProvider apiProvider = ApiProvider();

    var bookingsystem = "";
    if (isBookingSystem.value == true) {
      bookingsystem = "yes";
    }
    var discount = "";
    if (isDiscount.value == true) {
      discount = "yes";
    }
    arrRecommandedBestRated.clear();
    arrStoreList.clear();

    // ignore: unrelated_type_equality_checks
    var date = isDateSelected == true ? formatedDate.value : "";

    var url = ApiUrl.getserviceproviderlist +
        "?main_category=$mainCategorySelected" +
        "&date=$date" +
        "&search_text=${suggestionStr.value.text}" +
        "&pincode=$pincodeForSearch" +
        "&category_id=$selectedCategoryId" +
        "&subcategory_id=$selectedSubCategoryId" +
        "&booking_system=$bookingsystem" +
        "&discount=$discount" +
        "&home_type=$selectedOptions";

    print(url);
    apiProvider.getApiCall(url).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];

        arrRecommandedBestRated.value =
            TopRatedStore.getData(responsedata["top_rated_store"]);

        arrStoreList.value = StoreList.getData(responsedata["storeList"]);
        isLoader.value = false;
        addAllmarkersForMap();
      }

      //isLoader.value = false;
    });
  }

  void getAllDataForNewRecomandedTabs() {
    ApiProvider apiProvider = ApiProvider();
    isLoader.value = true;
    var bookingsystem = "";
    if (isBookingSystem.value == true) {
      bookingsystem = "yes";
    }
    var discount = "";
    if (isDiscount.value == true) {
      discount = "yes";
    }

    // ignore: unrelated_type_equality_checks
    var date = isDateSelected == true ? formatedDate.value : "";

    var url = ApiUrl.getserviceproviderlist +
        "?main_category=$mainCategorySelected" +
        "&date=$date" +
        "&search_text=${suggestionStr.value.text}" +
        "&pincode=$pincodeForSearch" +
        "&category_id=$selectedCategoryId" +
        "&subcategory_id=$selectedSubCategoryId" +
        "&booking_system=$bookingsystem" +
        "&discount=$discount" +
        "&home_type=$selectedOptions";

    apiProvider.getApiCall(url).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      arrRecommandedBestRated.clear();
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];

        arrRecommandedBestRated.value =
            TopRatedStore.getData(responsedata["top_rated_store"]);
        getSortByDataForDashboard();
      }
      isLoader.value = false;
    });
  }

  void getSortByDataForDashboard() {
    selectedPrice.value = "0";
    selectedRating.value = "0";
    selectedAddress.value = 'postCodeOrArea'.tr;
    pincode = "";
    selectedIds.clear();

    isLoader.value = true;
    ApiProvider apiProvider = ApiProvider();

    var bookingsystem = "";
    if (isBookingSystem.value == true) {
      bookingsystem = "yes";
    }
    var discount = "";
    if (isDiscount.value == true) {
      discount = "yes";
    }

    var body = {
      'sort_by': sortByText.value,
      'booking_value': bookingsystem,
      'discount': discount,
      'lat': "51.2212104",
      'long': "6.7919785"
    };
    print(body);
    apiProvider.post(ApiUrl.serviceshortby, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrStoreList.value = StoreList.getData(responsedata);
      }

      isLoader.value = false;
    });
  }

  void getSpecificationForFilter() {
    ApiProvider apiProvider = ApiProvider();
    apiProvider.getApiCall(ApiUrl.getspecifics).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrSpecifics.value = FliterSpecifics.getData(responsedata);
      }
    });
  }

  void applyFilter() {
    arrStoreList.clear();
    isLoader.value = false;
    ApiProvider apiProvider = ApiProvider();

    var bookingsystem = "";
    if (isBookingSystem.value == true) {
      bookingsystem = "yes";
    }

    var body = {
      'rating': "${selectedRating.value}",
      'category_id': "${selectedCategoryId.value}",
      'expensive': "${selectedPrice.value}",
      'filter_by_specifics': "$selectedIds",
      'booking_system': bookingsystem,
      'home_type': selectedOptions,
    };

    print(body);
    apiProvider.post(ApiUrl.applyFilter, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);

      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];


        arrStoreList.value = StoreList.getData(responsedata["storeList"]);

      } else {}

      isLoader.value = false;
    });
  }

  void getCategoryWiseSubCategory() {
    ApiProvider apiProvider = ApiProvider();

    if (selectedCategoryId.value.toString().isEmpty) {
      return;
    }

    var body = {
      "category_id": selectedCategoryId.value.toString(),
      "store_id": "",
    };
    print(body);
    apiProvider.post(ApiUrl.catewisesubcategory, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      arrCategoryWiseSubCategory.clear();
      arrCategoryWiseSubCategoryString.clear();

      selectedSubCategoryId.value = "";
      selectedSubCategoryName.value = 'subCategorys'.tr;

      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrCategoryWiseSubCategory.value =
            CategoryWiseSubCategory.getData(responsedata);

        for (CategoryWiseSubCategory temp in arrCategoryWiseSubCategory) {
          arrCategoryWiseSubCategoryString.add(temp.name);
        }
        sortByText.value = 'sort'.tr;

      } else {
        arrCategoryWiseSubCategoryString.clear();
      }
    });
  }

  void selectedSpecificationIdAdd(ind) {
    if (selectedIds.contains(ind)) {
      selectedIds.remove(ind);
    } else {
      selectedIds.add(ind);
    }
  }

  void resetFilters() {
    selectedPrice.value = "0";
    selectedRating.value = "0";
    selectedAddress.value = 'postCodeOrArea'.tr;
    pincode = "";
    sortByText = 'sort'.tr.obs;

    selectedIds.clear();

    markers.removeAll(markers);
    getAllDataForDashboard();
  }

  void doFavouriteFromServer(String storeid, String url, int currentIndex) {
    ApiProvider apiProvider = ApiProvider();

    var body = {"store_id": storeid};
    print(body);
    apiProvider.post(url, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        arrStoreList.value[currentIndex].favourite.value =
            // ignore: invalid_use_of_protected_member
            !arrStoreList.value[currentIndex].favourite.value;
      } else {}

      showTostMessage(message: _responseModel.responseText);
    });
  }

  Future<void> openPlacePicker(BuildContext context) async {
    PluginGooglePlacePicker.initialize(
      androidApiKey: googleAndroidApikey,
      iosApiKey: googleiOSApikey,
    );

    try {
      var placeName;
      var place = await PluginGooglePlacePicker.showAutocomplete(
        mode: PlaceAutocompleteMode.MODE_OVERLAY,
        countryCode: 'DE',
      );
      placeName = place;
      final coordinates =
          new Coordinates(placeName.latitude, placeName.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      pincodeForSearch = first.postalCode;
      selectedAddress.value = place.address;
    } on Exception catch (e) {
      print(e);
    }
  }

  void findSubCategoryIdFromName() {
    var obj = arrCategoryWiseSubCategory.firstWhere((element) {
      return element.name.contains(selectedSubCategoryName.value);
    });

    selectedSubCategoryId.value = obj.id.toString();
  }

  void getSuggestions({String searchtext}) {
    ApiProvider apiProvider = ApiProvider();

    var body = {"search_text": searchtext};
    print(body);
    apiProvider.post(ApiUrl.storesuggestion, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        arrStoreSuggestionString.clear();

        arrStoreSuggestionString.value = SuggestionData.getData(responsedata);
        isSuggestionPopUpOpen.value = false;
        // ignore: invalid_use_of_protected_member
        if (arrStoreSuggestionString.value.length > 0) {
          isSuggestionPopUpOpen.value = true;
        }
      } else {}
    });
  }

  void clearAllDataAndPullToRefresh() {
    isBookingSystem.value = true;
    isDiscount.value = false;
    sortByText.value = "sort".tr;
    selectedSubCategoryId.value = "";
    selectedSubCategoryName.value = 'subCategorys'.tr;
    pincodeForSearch = "";
    suggestionStr.value.text = "";
    selectedIndex.value = "";
    fabIconNumber.value = false;
    selectedCategoryId.value = "";
    selectedCategoryName.value = 'all'.tr;
    scrollController = ScrollController();
    isScroll.value = false;
    resetFilters();
    getAllCategoryData();

    refreshController.refreshCompleted();
  }

  void resetAdvanceSerach() {
    selectedSubCategoryId.value = "";
    selectedSubCategoryName.value = 'subCategorys'.tr;
    pincodeForSearch = "";
    suggestionStr.value.text = "";
    selectedAddress.value = 'postCodeOrArea'.tr;
    isDateSelected.value = false;
    isSuggestionPopUpOpen.value = false;
    getAllDataForDashboard();
    fabIconNumber.value = false;
  }

  void addAllmarkersForMap() {
    markersForMapView.clear();
    if (arrStoreList.length > 0) {
      var temp = arrStoreList.first;
      cameraPositionForMapView = CameraPosition(
        target:
            LatLng(double.parse(temp.latitude), double.parse(temp.longitude)),
        zoom: 15,
      );
    }

    for (StoreList temp in arrStoreList) {
      if (temp.latitude != null) {
        markersForMapView.add(Marker(
          markerId: MarkerId(temp.storeName),
          infoWindow: InfoWindow(
              title: temp.storeName,
              snippet: "⭐ ${temp.avgRating}"), // "★ ${temp.avgRating}"
          position:
              LatLng(double.parse(temp.latitude), double.parse(temp.longitude)),
        ));
      }
    }
  }

  void clearParticularStoreSelection() {
    ApiProvider apiProvider = ApiProvider();

    var body = {"store_id": "", "device_token": deviceId};
    print(body);
    apiProvider.post(ApiUrl.clearselectionstore, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
    });
  }
}
