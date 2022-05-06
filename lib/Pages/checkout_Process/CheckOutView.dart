import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/checkout_Process/CheckoutController.dart';
import 'package:reserve_for_you_user/Pages/checkout_Process/BookingSummeryForCheckOut.dart';

import 'BillingDetailsView.dart';
import 'CompletePayment.dart';

// ignore: must_be_immutable
class CheckoutProcess extends StatelessWidget {
  CheckoutController _checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    _checkoutController.context = context;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(AppColor.scaffoldbgcolor),
        appBar: appbar(),
        bottomNavigationBar: bottomNavBar(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Obx(
                  () => Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        //height: 120,
                        width: Get.width,
                        color: Color(AppColor.logoBgColor),
                        child: Column(
                          children: [
                            tabBar(),
                            SizedBox(
                              height: 12,
                            ),
                            textRow(),
                          ],
                        ),
                      ),
                      if (_checkoutController.selectedPage.value == 0)
                        BookingSummeryForCheckOut()
                      // ignore: unrelated_type_equality_checks
                      else if (_checkoutController.selectedPage.value == 1)
                        BillingDetail()
                      else
                        CompletePayment(),
                    ],
                  ),
                ),
              ),
              Obx(() => CommanWidget(context: context).showlolder(isshowDilog: _checkoutController.showLoader.value)),
            ],
          ),
        ),
      ),
    );
  }

  Widget textRow() {
    return Container(
      padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: Get.height * 0.05,
            width: Get.width * 0.20,
            child: Center(
              child: Text(
                'bookingSum'.tr,
                style: TextStyle(
                  fontFamily: AppFont.bold,
                  fontSize: 12,
                  color: _checkoutController.selectedPage.value == 0 ? Colors.black : Color(0xFFdb8a8a),
                ),
              ),
            ),
          ),
          Container(
            height: Get.height * 0.05,
            width: Get.width * 0.21,
            child: Center(
              child: Text(
                'billingDet'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFont.bold,
                  fontSize: 12,
                  color: _checkoutController.selectedPage.value == 1
                      ? Colors.black
                      : _checkoutController.isGoForward.value == false
                          ? Color(0xFFbab5b5)
                          : Color(0xFFdb8a8a),
                ),
              ),
            ),
          ),
          Container(
            height: Get.height * 0.05,
            width: Get.width * 0.20,
            child: Center(
              child: Text(
                'compeletePay'.tr,
                style: TextStyle(
                  fontFamily: AppFont.bold,
                  fontSize: 12,
                  color: _checkoutController.selectedPage.value == 2 ? Colors.black : Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row tabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Selected Index
        bookingSummery0(),

        // back index
        billingDetail1(),

        //unselected
        compeletePayment2(),
      ],
    );
  }

  // bookingSummery0
  Container bookingSummery0() {
    return Container(
      child: Row(
        children: [
          if (_checkoutController.selectedPage.value == 0) selectedContainer() else redContainer(),
          if (_checkoutController.selectedPage.value == 0) greyWidthContainer() else redWidthContainer(),
        ],
      ),
    );
  }

  // billingDetail1
  Container billingDetail1() {
    return Container(
      child: Row(
        children: [
          if (_checkoutController.selectedPage.value == 1) selectedContainer() else if (_checkoutController.isGoForward.value == false) unSelectedContainer() else redContainer(),
          if (_checkoutController.selectedPage.value == 1)
            greyWidthContainer()
          else if (_checkoutController.isGoForward.value == false)
            greyWidthContainer()
          else
            redWidthContainer(),
        ],
      ),
    );
  }

// compeletePayment2
  Widget compeletePayment2() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (_checkoutController.selectedPage.value == 2) selectedContainer() else unSelectedContainer(),
        ],
      ),
    );
  }

  Container selectedContainer() {
    return Container(
      width: Get.width * 0.20,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(9),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFf9bc64),
          ),
          child: Image.asset(
            AssestPath.detailScreen + "dot.png",
            height: 10,
          ),
        ),
      ),
    );
  }

  Container unSelectedContainer() {
    return Container(
      width: Get.width * 0.20,
      child: Center(
        child: Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: EdgeInsets.all(9),
          height: 25,
          width: 25,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(width: 1, color: Colors.grey[400])),
        ),
      ),
    );
  }

  Container redContainer() {
    return Container(
      width: Get.width * 0.20,
      child: Center(
        child: Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: EdgeInsets.all(9),
          height: 25,
          width: 25,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xFFdb8a8a)),
        ),
      ),
    );
  }

  Container greyWidthContainer() {
    return Container(
      margin: EdgeInsets.only(left: Get.width * 0.01, right: Get.width * 0.01),
      height: 2,
      width: 50,
      color: Colors.grey[300],
    );
  }

  Container redWidthContainer() {
    return Container(
      margin: EdgeInsets.only(left: Get.width * 0.01, right: Get.width * 0.01),
      height: 2,
      width: 50,
      color: Color(0xFFdb8a8a),
    );
  }

  AppBar appbar() {
    return AppBar(
      backgroundColor: Color(
        AppColor.scaffoldbgcolor,
      ),
      leading: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
        height: 35.0,
        width: 35.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              _checkoutController.removeOverlay();
              if (_checkoutController.selectedPage.value == 0) {
                Get.back();
                return;
              }
              _checkoutController.selectedPage.value -= 1;
              if (_checkoutController.selectedPage.value == 1) {
                _checkoutController.selectedPageTitle.value = 'proccedToPay'.tr;
                _checkoutController.isGoForward.value = false;
              }

              if (_checkoutController.selectedPage.value == 0) {
                _checkoutController.selectedPageTitle.value = 'proceedToBillingDetail'.tr;
              }
            },
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            backgroundColor: Color(AppColor.scaffoldbgcolor),
          ),
        ),
      ),
      title: Text(
        'checkOut'.tr,
        style: TextStyle(fontFamily: AppFont.semiBold, color: Colors.black, fontSize: 16),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  InkWell bottomNavBar() {
    return InkWell(
      onTap: () {
        if (_checkoutController.selectedPage.value == 2) {
          _checkoutController.doPaymentStatsWise();
          return;
        }
        if (_checkoutController.selectedPage.value == 1 && _checkoutController.checkValidation()) {
          _checkoutController.selectedPage.value += 1;

          if (_checkoutController.selectedPage.value == 2) {
            _checkoutController.selectedPageTitle.value = 'payTo'.tr;
            /*+ " ${_checkoutController.totalPrice.toStringAsFixed(2)} " +
                appStaticPriceSymbol;*/
            _checkoutController.isGoForward.value = true;
          }
        } else if (_checkoutController.selectedPage.value != 1) {
          _checkoutController.selectedPage.value += 1;
          _checkoutController.selectedPageTitle.value = 'proccedToPay'.tr;
          if (_checkoutController.selectedPage.value == 2) {
            _checkoutController.isGoForward.value = true;
          }
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        height: 80,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Color(0xFFdb8a8a),
        ),
        child: Container(
          // margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Center(
            child: Obx(() => bottomBarText(
                  text: _checkoutController.selectedPageTitle.value,
                )),
          ),
        ),
      ),
    );
  }

  Text bottomBarText({text}) {
    return Text(
      "$text",
      style: TextStyle(color: Color(AppColor.scaffoldbgcolor), fontFamily: AppFont.semiBold, fontSize: 18),
    );
  }
}
