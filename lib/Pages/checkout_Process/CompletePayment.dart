import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/checkout_Process/CheckoutController.dart';
import 'package:pay/pay.dart' as pay;

const _paymentItems = [
  pay.PaymentItem(
    label: 'Total',
    amount: '0.01',
    status: pay.PaymentItemStatus.final_price,
  )
];

// ignore: must_be_immutable

class CompletePayment extends StatefulWidget {
  @override
  State<CompletePayment> createState() => _CompletePaymentState();
}

class _CompletePaymentState extends State<CompletePayment> {
  CheckoutController checkoutController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutController.totalPrice);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('completePayment'.tr, style: TextStyle(fontSize: 22, fontFamily: AppFont.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12.0, crossAxisSpacing: 8.0, mainAxisExtent: 85),
            itemCount: checkoutController.paymentText.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    checkoutController.selectedPaymentInd.value = index;
                    if (checkoutController.paymentText.length == 1) {
                      checkoutController.paymentmethod = "cash";
                    } else {
                      if (index == 0) {
                        checkoutController.paymentmethod = "stripe";
                      }
                      if (index == 1) {
                        checkoutController.paymentmethod = "stripe";
                      }
                      if (index == 2) {
                        checkoutController.paymentmethod = "klarna";
                      }
                      if (index == 3) {
                        checkoutController.paymentmethod = "cash";
                      }
                      if (index == 4) {
                        if (Platform.isIOS) {
                          checkoutController.paymentmethod = "applepay";
                        } else {
                          print('else');
                          checkoutController.paymentmethod = "googlepay";
                        }
                      }
                    }
                    print(checkoutController.paymentmethod);
                    print("checkoutController.paymentmethod");
                  },
                  child: cardPayment(checkoutController.images[index], index, checkoutController.paymentText[index]));
            },
          ),
          Obx(
            () => Visibility(
              visible: (checkoutController.selectedPaymentInd.value == 0 && checkoutController.paymentmethod == "stripe")
                  ? true
                  : checkoutController.selectedPaymentInd.value == 1
                      ? true
                      : false,
              child: cardContainer(),
            ),
          ),
          bookingCondition(),
        ],
      ),
    );
  }

  Widget cardContainer() {
    return Column(
      children: [
        const SizedBox(height: 20),
        cardNumber(),
        const SizedBox(height: 8),
        dateCvv(),
        const SizedBox(height: 15),
        Obx(() => saveCard()),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget cardPayment(String images, int ind, [String name]) {
    return Stack(
      children: [
        Obx(
          () => Container(
            height: 90,
            width: Get.width,
            decoration: BoxDecoration(
              color: checkoutController.selectedPaymentInd.value == ind ? Color(0xFFFDF1F1) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12, width: 2),
            ),
            child: ind == 4 && Platform.isIOS
                ? Stack(
                    children: [
                      pay.ApplePayButton(
                        height: 90,
                        paymentConfigurationAsset: 'apple_pay_payment_profile.json',
                        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                      ),
                      GestureDetector(onTap: () {
                        checkoutController.selectedPaymentInd.value = 4;
                        checkoutController.paymentmethod = "applepay";
                        print(checkoutController.paymentmethod);
                      }),
                    ],
                  )
                : ind == 4 && Platform.isAndroid
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/GPay_Acceptance_Mark_800.png',
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: () {
                              checkoutController.selectedPaymentInd.value = 4;
                              checkoutController.paymentmethod = "googlepay";
                              print(checkoutController.paymentmethod);
                            },
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("$images", height: 20, fit: BoxFit.cover),
                          const SizedBox(height: 10),
                          Text(
                            "$name",
                            style: TextStyle(fontSize: 13, fontFamily: AppFont.medium),
                          ),
                        ],
                      ),
          ),
        )
      ],
    );
  }

  Widget cardNumber() {
    return Container(
      height: 60,
      width: Get.width,
      decoration: BoxDecoration(color: Color(AppColor.maincategoryDisableColor), borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: checkoutController.cardNumber,
          maxLength: 16,
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TextStyle(
            fontFamily: AppFont.medium,
            fontSize: 15,
          ),
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              hintText: 'cardNumber'.tr,
              counterText: "",
              hintStyle: TextStyle(color: Colors.black45, fontFamily: AppFont.medium)),
        ),
      ),
    );
  }

  var month;

  var year;

  Widget dateCvv() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 60,
          width: Get.width * 0.43,
          decoration: BoxDecoration(color: Color(AppColor.maincategoryDisableColor), borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: checkoutController.expDate,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, birthDate, LengthLimitingTextInputFormatter(7)],
              onChanged: (date) {
                checkoutController.expDate
                  ..text = date
                  ..selection = TextSelection.collapsed(offset: checkoutController.expDate.text.length);
              },
              style: TextStyle(
                fontFamily: AppFont.medium,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  hintText: 'mm/yyyy'.tr,
                  hintStyle: TextStyle(color: Colors.black45, fontFamily: AppFont.medium)),
            ),
          ),
        ),
        Container(
          height: 60,
          width: Get.width * 0.43,
          decoration: BoxDecoration(color: Color(AppColor.maincategoryDisableColor), borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: checkoutController.cvv,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 3,
              style: TextStyle(
                fontFamily: AppFont.medium,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  counterText: "",
                  hintText: 'cvv'.tr,
                  hintStyle: TextStyle(color: Colors.black45, fontFamily: AppFont.medium)),
            ),
          ),
        ),
      ],
    );
  }

  Widget saveCard() {
    return InkWell(
      onTap: () {
        checkoutController.isSaveCardForNextTime.value = !checkoutController.isSaveCardForNextTime.value;
        checkoutController.saveCardDetailsForNextPayment();
      },
      child: Container(
        height: 50,
        width: Get.width,
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(18)),
              child: Visibility(
                visible: checkoutController.isSaveCardForNextTime.value,
                child: Image.asset(AssestPath.detailScreen + "check-mark.png"),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'saveCardForNextPayment'.tr,
              style: TextStyle(color: Colors.black45, fontFamily: AppFont.medium, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  Widget bookingCondition() {
    return Container(
      height: 50,
      width: Get.width,
      color: Color(AppColor.maincategoryDisableColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'byContinuing'.tr,
            style: TextStyle(fontSize: 12, fontFamily: AppFont.medium),
          ),
          const SizedBox(width: 2),
          Text(
            'bookingCondition'.tr,
            style: TextStyle(fontFamily: AppFont.medium, decoration: TextDecoration.underline, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

final _UsNumberTextInputFormatter birthDate = new _UsNumberTextInputFormatter();

class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 3) {
      print('iiiiiiiii');
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= usedSubstringIndex) newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
