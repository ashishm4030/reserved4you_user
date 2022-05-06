import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';

import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/checkout_Process/CheckoutController.dart';

// ignore: use_key_in_widget_constructors
// ignore: must_be_immutable
class BillingDetail extends StatefulWidget {
  @override
  State<BillingDetail> createState() => _BillingDetailState();
}

class _BillingDetailState extends State<BillingDetail> {
  CheckoutController _checkoutController = Get.find();

  bool phoneIsFocus = false;

  @override
  void initState() {
    _checkoutController.phoneFocus.addListener(() {
      if (Platform.isIOS) {
        phoneIsFocus = _checkoutController.phoneFocus.hasFocus;
        if (phoneIsFocus)
          _checkoutController.showOverlay(context);
        else
          _checkoutController.removeOverlay();
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'bookingDetail'.tr,
            style: TextStyle(fontSize: 22, fontFamily: AppFont.bold),
          ),
          const SizedBox(height: 20),
          CommanWidget(context: context).textFeildWithImage(
            hintText: 'firstnamehint'.tr,
            imgUrl: AssestPath.login + "User.png",
            keyboardType: TextInputType.emailAddress,
            textEditingController: _checkoutController.fname,
            height: 20,
            width: 20,
            focusNode: _checkoutController.fNameFocus,
          ),
          Obx(() => errorText(_checkoutController.firstNameEmpty.value)),
          const SizedBox(height: 15),
          /*Last Name*/ CommanWidget(context: context).textFeildWithImage(
            hintText: 'lastnamehint'.tr,
            imgUrl: AssestPath.login + "User.png",
            keyboardType: TextInputType.emailAddress,
            textEditingController: _checkoutController.lname,
            height: 20,
            width: 20,
            focusNode: _checkoutController.lNameFocus,
          ),
          Obx(() => errorText(_checkoutController.lastNameEmpty.value)),
          const SizedBox(height: 15),
          Obx(() => CommanWidget(context: context).textFeildWithImage(
                hintText: 'email'.tr,
                imgUrl: AssestPath.login + "Email.png",
                keyboardType: TextInputType.emailAddress,
                textEditingController: _checkoutController.emailText,
                height: 20,
                enable: _checkoutController.emailEnable.value,
                width: 20,
                focusNode: _checkoutController.emailFocus,
              )),
          /*Email Address*/
          Obx(() => errorText(_checkoutController.emailEmpty.value)),
          const SizedBox(height: 15),
          /*Phone Number*/
          textFeildWithImagePhoneNumber(
            hintText: 'phoneNumber'.tr,
            maxLength: 13,
            imgUrl: AssestPath.login + "Call1.png",
            /*keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),*/
            keyboardType: TextInputType.phone,
            textEditingController: _checkoutController.phnNoText,
            focusNode: _checkoutController.phoneFocus,
            height: 20,
            width: 20,
          ),
          Obx(() => errorText(_checkoutController.phoneNoEmpty.value)),
          SizedBox(height: phoneIsFocus ? 65 : 0),
        ],
      ),
    );
  }

  Widget textFeildWithImagePhoneNumber({
    String titleText,
    String hintText,
    String imgUrl,
    TextInputType keyboardType,
    TextEditingController textEditingController,
    double height,
    double width,
    FocusNode focusNode,
    bool isSecure = false,
    int maxLength = 200,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(color: Color(AppColor.textFieldBg), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          SizedBox(
            width: 20.0,
          ),
          Image.asset(
            imgUrl,
            fit: BoxFit.fill,
            height: height,
            width: width,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              keyboardType: keyboardType,
              obscureText: isSecure,
              maxLength: maxLength,
              focusNode: focusNode,
              inputFormatters: [
                //FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(
                fontFamily: AppFont.medium,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                counterText: "",
                hintStyle: TextStyle(color: Color(AppColor.textFieldtextColor), fontFamily: AppFont.medium, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(AppColor.textFieldBg),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget errorText(String error) {
    if (error != "") {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 11.5),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
