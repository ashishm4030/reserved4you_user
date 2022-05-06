import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/ResponseModel.dart';
import 'package:reserve_for_you_user/Helper/apiProvider.dart';
import 'package:reserve_for_you_user/Helper/commanFuncation.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/Authentication/Login/LoginModel.dart';
import 'package:reserve_for_you_user/Pages/BookingSummary/BookingSummaryModel.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/ProceedToPayController.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/SelectedServiceModel.dart';
import 'package:pay/pay.dart' as pay;

// const paymentItems = [
//   pay.PaymentItem(
//     label: 'Total',
//     amount: '02.00',
//     type: pay.PaymentItemType.item,
//     status: pay.PaymentItemStatus.final_price,
//   )
// ];

class CheckoutController extends GetxController {
  var servcesIcon = true.obs;
  var isGoForward = false.obs;
  var selectedPage = 0.obs; // 0 summary, 1 Billing details, 2 complete payment
  var selectedPageTitle = 'proceedToBillingDetail'.tr.obs;
  ProceedToPayController _proceedToPayController = Get.find();
  StoreDetailController storeDetailController = Get.find();
  // ignore: deprecated_member_use
  var arrSelectedServices = List<SelectedServiceModel>().obs;
  BuildContext context;
  var deviceId;
  TextEditingController emailText;
  TextEditingController phnNoText;
  TextEditingController fname;
  TextEditingController lname;
  var selectedPaymentInd = 0.obs;
  TextEditingController cardNumber;
  TextEditingController expDate;
  TextEditingController cvv;
  var curruntIndex = 0.obs;

  var isSaveCardForNextTime = false.obs;
  var paymentmethod = PaymentMethods.masterCard;
  var stripeToken = "";
  var arrTemp = [];
  var selectedStoreId = "";
  var bookingSummaryObj = BookingSummaryData();
  var showLoader = false.obs;
  var totalPrice = 0.00;

  var firstNameEmpty = "".obs;
  var lastNameEmpty = "".obs;
  var emailEmpty = "".obs;
  var phoneNoEmpty = "".obs;

  var karlnaPaypalUrl = "";
  RxBool emailEnable = true.obs;
  final FocusNode fNameFocus = FocusNode();
  final FocusNode lNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  OverlayEntry overlayEntry;

  var paymentText = [
    'masterCard'.tr,
    'visaCard'.tr,
    'klarna'.tr,
    // 'payPal'.tr,
    'cashOnVenue'.tr,
    Platform.isAndroid ? 'GooglePay'.tr : 'ApplePay'.tr,
  ];

  var images = [
    AssestPath.detailScreen + "Master Card.png",
    AssestPath.detailScreen + "Visa.png",
    AssestPath.detailScreen + "Klarna.png",
    // AssestPath.detailScreen + "PayPal-Logo.wine.png",
    AssestPath.detailScreen + "Cash at Venue.png",
    Platform.isAndroid ? "assets/Group 66513.png" : "assets/Group 66544.png"
  ];

  @override
  void onInit() async {
    super.onInit();
    arrSelectedServices.value = _proceedToPayController.arrSelectedServices;
    totalPrice = _proceedToPayController.totalPrice.value;
    emailText = TextEditingController();
    phnNoText = TextEditingController();
    fname = TextEditingController();
    lname = TextEditingController();
    cardNumber = TextEditingController();
    expDate = TextEditingController();
    cvv = TextEditingController();

    cardNumber.text = "";
    expDate.text = "";
    cvv.text = "";

    CommonVariables(context: context).getId().then((value) {
      deviceId = value;
    });
    ProceedToPayController _storeDetailController = Get.find();
    selectedStoreId = _storeDetailController.selectedStoreid;

    checkIfCardSaveAndDataDispaly();
    checkLoginUserDetails();
    createArrayForAppoinment();

    // StripePayment.setOptions(
    //     StripeOptions(publishableKey: "pk_test_pyAji6er6sj1KeM06MlYOTsy00dkDuHTU2", merchantId: "sk_test_hHiwaXoEWblwzGpUgMsR9W0M00GwOAS2NB", androidPayMode: 'Reserved4you'));
    print(storeDetailController.storeDetailsObj.value.paymentMethod.toLowerCase());
    print("storeDetailController.storeDetailsObj.value.paymentMethod.toLowerCase()");
    if (storeDetailController.storeDetailsObj.value.paymentMethod == null || storeDetailController.storeDetailsObj.value.paymentMethod.toLowerCase() == "both".toLowerCase()) {
      paymentText = [
        'masterCard'.tr,
        'visaCard'.tr,
        'klarna'.tr,
        // 'payPal'.tr,
        'cashOnVenue'.tr,
        Platform.isAndroid ? 'GooglePay'.tr : 'ApplePay'.tr,
      ];
      images = [
        AssestPath.detailScreen + "Master Card.png",
        AssestPath.detailScreen + "Visa.png",
        AssestPath.detailScreen + "Klarna.png",
        // AssestPath.detailScreen + "PayPal-Logo.wine.png",
        AssestPath.detailScreen + "Cash at Venue.png",
        Platform.isAndroid ? "assets/Group 66513.png" : "assets/Group 66544.png"
      ];
      paymentmethod = PaymentMethods.masterCard;
    } else if (storeDetailController.storeDetailsObj.value.paymentMethod.toLowerCase() == "cash".toLowerCase()) {
      paymentmethod = PaymentMethods.cash;
      paymentText = [
        'cashOnVenue'.tr,
      ];

      images = [AssestPath.detailScreen + "Cash at Venue.png"];
      paymentmethod = PaymentMethods.cash;
    } else if (storeDetailController.storeDetailsObj.value.paymentMethod.toLowerCase() == "card".toLowerCase()) {
      paymentText = [
        'masterCard'.tr,
        'visaCard'.tr,
        'klarna'.tr,
        // 'payPal'.tr,
      ];

      images = [
        AssestPath.detailScreen + "Master Card.png",
        AssestPath.detailScreen + "Visa.png",
        AssestPath.detailScreen + "Klarna.png",
        // AssestPath.detailScreen + "PayPal-Logo.wine.png",
        // Platform.isAndroid ? "assets/Group 66513.png" : "assets/Group 66512.png"
      ];
      paymentmethod = PaymentMethods.masterCard;
    }
  }

  void checkLoginUserDetails() async {
    var isLogin = await Preferences.preferences.getBool(key: PrefernceKey.isUserLogin, defValue: false);
    var isGuestUser = await Preferences.preferences.getBool(key: PrefernceKey.isGuestUser, defValue: false);

    if (isLogin || isGuestUser) {
      setUserDataForLogin();
    } else {}
  }

  void setUserDataForLogin() async {
    var userData = await Preferences.preferences.getString(key: PrefernceKey.userData);

    var loginUserDataObj = LoginModel.fromJson(jsonDecode(userData));

    emailText.text = loginUserDataObj.email;
    lname.text = loginUserDataObj.lastName;
    fname.text = loginUserDataObj.firstName;
    phnNoText.text = loginUserDataObj.phonenumber;
    emailEnable.value = (emailText.text.trim() == '');
  }

  bool checkValidation() {
    setErrorText();
    if (fname.text.trim().isEmpty) {
      showTostMessage(message: 'tostfirstname'.tr);
      return false;
    } else if (lname.text.trim().isEmpty) {
      showTostMessage(message: 'tostlastname'.tr);
      return false;
    } else if (emailText.text.trim().isEmpty) {
      showTostMessage(message: 'tostemail'.tr);
      return false;
    } else if (CommonVariables(context: context).validationEmail(input: emailText.text) == false) {
      showTostMessage(message: 'tostVemail'.tr);
      return false;
    } else if (phnNoText.text.length < 11 || GetUtils.isPhoneNumber(phnNoText.text) == false) {
      showTostMessage(message: 'phoneNumberValid'.tr);
      return false;
    } else {
      return true;
    }
  }

  void setErrorText() {
    if (fname.text.trim().isEmpty) {
      firstNameEmpty.value = 'tostlastname'.tr;
    } else {
      firstNameEmpty.value = "";
    }

    if (lname.text.trim().isEmpty) {
      lastNameEmpty.value = 'tostlastname'.tr;
    } else {
      lastNameEmpty.value = "";
    }

    if (emailText.text.trim().isEmpty) {
      emailEmpty.value = 'tostemail'.tr;
    } else {
      if (CommonVariables(context: context).validationEmail(input: emailText.text) == false) {
        emailEmpty.value = 'tostVemail'.tr;
      } else {
        emailEmpty.value = "";
      }
    }

    if (GetUtils.isPhoneNumber(phnNoText.text) == false) {
      phoneNoEmpty.value = 'phoneNumberValid'.tr;
    } else if (phnNoText.text.length < 11) {
      phoneNoEmpty.value = 'phoneNumberValid'.tr;
    } else {
      phoneNoEmpty.value = "";
    }
  }

  void withDrawPaymentToServer() async {
    showLoader.value = true;
    ApiProvider apiProvider = ApiProvider();
    var arrStr = expDate.text.split("/");
    print('arrStr.first.toString()');
    print(arrStr.first.toString());
    print(arrStr.last.toString());
    var body = {
      'store_id': selectedStoreId.toString(),
      'amount': totalPrice.toString(),
      // 'stripeToken': stripeToken,
      'payment_method': paymentmethod,
      'first_name': fname.text,
      'last_name': lname.text,
      'email': emailText.text,
      'phone_number': phnNoText.text,
      'AppoData': jsonEncode(arrTemp),
      'device_token': deviceId,
      'card_number': '${cardNumber.text.toString()}',
      'ex_month': "${arrStr.first.toString()}",
      'ex_year': "${arrStr.last.toString()}",
      'cvv': "${cvv.text.toString()}",
    };

    print('lbkjkkhkjhjhjhkjh');
    print(jsonEncode(body));

    await apiProvider.post(ApiUrl.withdrawpayment, body).then(
      (value) {
        print('value.body');
        print(value.body);
        var responseJson = json.decode(value.body);
        print('responseJson');
        print(responseJson);
        ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
        print(_responseModel.responseText);
        if (_responseModel.responseCode == 0 && _responseModel.responseText == "Fails") {
          print('responseJson11');
          print(_responseModel.responseText);
          showLoader.value = false;
          showTostMessage(message: _responseModel.responseText);
          showMyDialog();
          clearParticularStoreSelection();
        } else if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
          var responsedata = responseJson["ResponseData"];
          goToDifferentPagesForPayment(responsedata);
          showTostMessage(message: _responseModel.responseText);
          showLoader.value = false;
          print('responseJson22');
        } else {
          print('responseJsonElse');
          print('_responseModel.responseText');
          print(_responseModel.responseText);
          showTostMessage(message: _responseModel.responseText);
          showLoader.value = false;
        }
        showLoader.value = false;
      },
    );
  }

  void checkPaymentStatusForKarlnaPaypal() async {
    showLoader.value = true;
    ApiProvider apiProvider = ApiProvider();
    print(karlnaPaypalUrl);
    await apiProvider.getApiCall(karlnaPaypalUrl).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
      ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
      if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
        var responsedata = responseJson["ResponseData"];
        bookingSummaryObj = BookingSummaryData.fromJson(responsedata);
        bookingSummaryObj.isSuccess = 1;
        Get.toNamed("/confirmPaymentView", arguments: bookingSummaryObj);
      } else if (_responseModel.responseCode == 0) {
        var responsedata = responseJson["ResponseData"];
        bookingSummaryObj = BookingSummaryData.fromJson(responsedata);
        bookingSummaryObj.isSuccess = 0;
        Get.toNamed("/confirmPaymentView", arguments: bookingSummaryObj);
      }

      showLoader.value = true;
    });
  }

  void goToDifferentPagesForPayment(dynamic responsedata) {
    if (paymentmethod == PaymentMethods.cash || paymentmethod == PaymentMethods.masterCard || paymentmethod == PaymentMethods.visaCard) {
      bookingSummaryObj = BookingSummaryData.fromJson(responsedata);
      bookingSummaryObj.isSuccess = 1;
      Get.toNamed("/confirmPaymentView", arguments: bookingSummaryObj);
    } else if (paymentmethod == PaymentMethods.paypal || paymentmethod == PaymentMethods.klarna) {
      var obj = KlarnaPaypal.fromJson(responsedata);
      Get.toNamed("/paypalView", arguments: obj);
    }
  }

  void createArrayForAppoinment() {
    arrTemp.clear();
    for (SelectedServiceModel obj in arrSelectedServices) {
      for (Servicecategory serCate in obj.servicecategory) {
        addDataToArray(
          arr: serCate.serviceVariant,
          subcategoryid: serCate.subcategoryId.toString(),
          appDate: obj.appodate,
          appotime: obj.appotime,
          servicename: serCate.serviceName,
          empId: obj.empids.toString(),
          serviceid: serCate.id.toString(),
        );
      }
    }
    print("arrTemp---------> $arrTemp");
  }

  void addDataToArray({
    List<SelectedServiceVariant> arr,
    String subcategoryid,
    String appDate,
    String appotime,
    String servicename,
    String empId,
    String serviceid,
  }) {
    for (SelectedServiceVariant objVarient in arr) {
      var temp = {
        "category_id": objVarient.categoryId.toString(),
        "subcategory_id": subcategoryid,
        "store_emp_id": empId,
        "appo_date": appDate,
        "appo_time": appotime,
        "service_id": serviceid.toString(),
        "service_name": servicename,
        "variant_id": objVarient.serviceVariantId.toString(),
        "price": objVarient.vpricefinal.toString(),
      };
      arrTemp.add(temp);
    }
  }

  void checkValidationForCards() {
    if (cardNumber.text.isEmpty) {
      showTostMessage(message: 'enterCardNumber'.tr);
    } else if (cvv.text.isEmpty) {
      showTostMessage(message: 'enterCvv'.tr);
    }
  }

  void addCardInStripeForCreateToken() async {
    // final CreditCard testCard = CreditCard(
    //   number: '${cardNumber.text.toString()}',
    //   expMonth: int.parse("${arrStr.first.toString()}"),
    //   expYear: int.parse("${arrStr.last.toString()}"),
    //   cvc: "${cvv.text.toString()}",
    // );
    // print('testCard');
    // print(int.parse("${arrStr.first.toString()}"));
    // print(int.parse("${arrStr.last.toString()}"));
    // print(int.parse("${cvv.text.toString()}"));
    // print(int.parse("${cardNumber.text.toString()}"));
    // await StripePayment.createTokenWithCard(testCard).then((value) {
    //   print("Stripe token ${value.tokenId}");
    //   print("Stripe token ${testCard}");
    //   stripeToken = value.tokenId;
    //   withDrawPaymentToServer();
    // }).catchError((onError) {
    //   print('onError');
    //   print(onError);
    // });
  }

  void doPaymentStatsWise() {
    print('apicall');
    print(paymentmethod);
    print(PaymentMethods.applePay);
    if (paymentmethod == PaymentMethods.cash) {
      withDrawPaymentToServer();
    } else if (paymentmethod == PaymentMethods.masterCard || paymentmethod == PaymentMethods.visaCard) {
      print('jhjkhlhjkhklj');
      if (checkValidationForCardNumbers()) {
        print('checkValidationForCardNumbers');
        // addCardInStripeForCreateToken();
        withDrawPaymentToServer();
      }
    } /*else if (paymentmethod == PaymentMethods.paypal) {
      print('kkk');
      withDrawPaymentToServer();
    }*/
    else if (paymentmethod == PaymentMethods.klarna) {
      print('lll');
      withDrawPaymentToServer();
    } else if (paymentmethod.toLowerCase() == PaymentMethods.applePay.toLowerCase() || paymentmethod.toLowerCase() == PaymentMethods.googlePay.toLowerCase()) {
      print('hhghgghghgh');
      paymentSheet(context: context, price: totalPrice.toString());
    }
  }

  bool checkValidationForCardNumbers() {
    if (cardNumber.text.isEmpty || cardNumber.text.length != 16) {
      showTostMessage(message: 'enterValidCardNumber'.tr);
    } else if (expDate.text.isEmpty) {
      showTostMessage(message: 'enterExpiryDate'.tr);
    } else if (cvv.text.isEmpty) {
      showTostMessage(message: 'enterCardCvv'.tr);
    } else {
      return true;
    }
    return false;
  }

  void saveCardDetailsForNextPayment() {
    var temp = ["${cardNumber.text}", "${expDate.text}", "${cvv.text}"];
    Preferences.preferences.saveString(value: jsonEncode(temp), key: PrefernceKey.saveCardData);
    Preferences.preferences.saveBool(key: PrefernceKey.isSaveCardData, value: isSaveCardForNextTime.value);
  }

  void checkIfCardSaveAndDataDispaly() async {
    var isCardSave = await Preferences.preferences.getBool(key: PrefernceKey.isSaveCardData, defValue: false);

    isSaveCardForNextTime.value = isCardSave;

    if (isSaveCardForNextTime.value) {
      var cardStr = await Preferences.preferences.getString(key: PrefernceKey.saveCardData);
      List cardjsn = jsonDecode(cardStr);

      cardNumber.text = cardjsn.first;
      expDate.text = cardjsn[1];
      cvv.text = cardjsn.last;
    }
  }

/////   APPLEPAY INTEGRATION
  Future<void> onApplePayResult(paymentResult) async {
    try {
      debugPrint(paymentResult.toString());
      // print('paymentResult');
      // print(paymentResult["paymentMethod"]);
      // print(paymentResult);
      // 1. Get Stripe token from payment result
      final token = await Stripe.instance.createApplePayToken(paymentResult);
      print(token);
      print(token.id);
      // final params = PaymentMethodParams.cardFromToken(token: token.id);
      // final paramss = PaymentMethodParams.giroPay(billingDetails: BillingDetails(email: emailText.text, name: fname.text));
      // print(paramss);
      // print('paramss');
      // final test = await Stripe.instance.createPaymentMethod(params);
      // print('jhfjfhgjhgjhghjgjh');
      // print(test);
      // print('tokengggggg');
      print(token);
      print(token.id);
      await withDrawPaymentToServerPay(token: token.id /*, PaymentMethod: jsonEncode(test)*/);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /////    GOOGLEPAY INTEGRATION

/*
  Future<void> onGooglePayResult(paymentResult) async {
    try {
      // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
      debugPrint(paymentResult.toString());
      // print('paymentResult');
      // print(paymentResult);
      final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
      // print('token');
      // print(token);
      final tokenJson = Map.castFrom(json.decode(token));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tokenJson['id'])));
      // print('tokenJson');
      // print(tokenJson);
      // print(tokenJson['id']);
      await withDrawPaymentToServerPay(token: tokenJson['id']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
*/
  Future<void> onGooglePayResult(paymentResult) async {
    try {
      // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
      debugPrint(paymentResult.toString());
      print('paymentResult');
      print(paymentResult);
      final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
      print('token');
      print(token);
      final tokenJson = Map.castFrom(json.decode(token));
      print('tokenJson');
      print(tokenJson);
      print('tokenJson');
      print(tokenJson['id']);
      await withDrawPaymentToServerPay(token: tokenJson['id']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

/*
  Future paymentSheet({BuildContext context, String price}) async {
    dynamic _paymentItems = [
      pay.PaymentItem(
        label: 'To reserved4you',
        amount: price,
        type: pay.PaymentItemType.item,
        status: pay.PaymentItemStatus.final_price,
      ),
    ];
    Pay payClient;
    if (Platform.isIOS) {
      payClient = Pay.withAssets(['apple_pay_payment_profile.json']);
    } else {
      print('eeeeeeeee');
      payClient = Pay.withAssets(['google_pay_payment_profile.json']);
    }
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('GPayStart')));
    // print('googlepay start');
    try {
      Map<String, dynamic> result = await payClient.showPaymentSelector(paymentItems: _paymentItems);
      print('hjjgjhgjjhfgjhfgj');
      print(result.toString());
      if (Platform.isIOS) {
        return onApplePayResult(result);
      } else {
        print('resulthhhhhhhhhhhhhhhh');
        print(result);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('GPayResult: $result')));
        return onGooglePayResult(result);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      return false;
    }
  }
*/

  Future paymentSheet({BuildContext context, String price}) async {
    dynamic _paymentItems = [
      pay.PaymentItem(
        label: 'To reserved4you',
        amount: price,
        type: pay.PaymentItemType.item,
        status: pay.PaymentItemStatus.final_price,
      ),
    ];
    Pay payClient;
    if (Platform.isIOS) {
      payClient = Pay.withAssets(['apple_pay_payment_profile.json']);
    } else {
      print('eeeeeeeee');
      payClient = Pay.withAssets(['google_pay_payment_profile.json']);
    }
    try {
      Map<String, dynamic> result = await payClient.showPaymentSelector(paymentItems: _paymentItems);
      if (Platform.isIOS) {
        return onApplePayResult(result);
      } else {
        print('result');
        print(result);
        return onGooglePayResult(result);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      return false;
    }
  }

  Future withDrawPaymentToServerPay({var token, var PaymentMethod}) async {
    showLoader.value = true;
    ApiProvider apiProvider = ApiProvider();
    showTostMessage(message: 'Api call Started');
    var body = {
      'store_id': selectedStoreId.toString(),
      'amount': totalPrice.toString(),
      'stripeToken': token,
      'payment_method': paymentmethod,
      'first_name': fname.text,
      'last_name': lname.text,
      'email': emailText.text,
      'phone_number': phnNoText.text,
      'AppoData': jsonEncode(arrTemp),
      'device_token': deviceId,
      // 'paymentMethod': PaymentMethod,
    };

    await apiProvider.post(ApiUrl.withdrawpayment, body).then(
      (value) {
        showTostMessage(message: 'Api call Done');
        var responseJson = json.decode(value.body);
        ResponseModel _responseModel = ResponseModel.fromJson(responseJson);
        print(_responseModel.responseText);
        if (_responseModel.responseCode == 0 && _responseModel.responseText == "Fails") {
          showLoader.value = false;
          showTostMessage(message: _responseModel.responseText);
          showMyDialog();
          clearParticularStoreSelection();
        } else if (_responseModel.responseCode == ResponseCodeForAPI.sucessC) {
          var responsedata = responseJson["ResponseData"];
          bookingSummaryObj = BookingSummaryData.fromJson(responsedata);
          bookingSummaryObj.isSuccess = 1;
          Get.toNamed("/confirmPaymentView", arguments: bookingSummaryObj);
          showTostMessage(message: _responseModel.responseText);
          showLoader.value = false;
        } else {
          showTostMessage(message: _responseModel.responseText);
          showLoader.value = false;
        }
        showLoader.value = false;
      },
    );
  }

  showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'failed'.tr,
            style: TextStyle(
              fontFamily: AppFont.semiBold,
              fontSize: 15,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'dateNotAailble'.tr,
                  style: TextStyle(
                    fontFamily: AppFont.regular,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'closeDilog'.tr,
                style: TextStyle(
                  fontFamily: AppFont.semiBold,
                  fontSize: 15,
                  color: Color(0xFFdb8a8a),
                ),
              ),
              onPressed: () {
                ProceedToPayController proceedToPay = Get.find();
                proceedToPay.getSelectedServiceDataToServer();
                Get.back();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void clearParticularStoreSelection() {
    ApiProvider apiProvider = ApiProvider();

    var body = {"store_id": "", "device_token": deviceId, "flag": true.toString()};
    print(body);
    apiProvider.post(ApiUrl.clearselectionstore, body).then((value) {
      var responseJson = json.decode(value.body);
      print(responseJson);
    });
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(bottom: MediaQuery.of(context).viewInsets.bottom, right: 0.0, left: 0.0, child: doneButton(context));
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  Widget doneButton(context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          child: CupertinoButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
