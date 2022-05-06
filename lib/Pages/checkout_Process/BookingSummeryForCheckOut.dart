import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanFuncation.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/SelectedServiceModel.dart';
import 'package:reserve_for_you_user/Pages/checkout_Process/CheckoutController.dart';

// ignore: must_be_immutable
class BookingSummeryForCheckOut extends StatelessWidget {
  CheckoutController checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return bookingSummery(context);
  }

  Widget bookingSummery(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          /*Title*/ Text(
            'bookingSummery'.tr,
            style: TextStyle(
              fontFamily: AppFont.bold,
              fontSize: 20,
            ),
          ),
          /*Service Details*/ Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(AppColor.textFieldBg),
            ),
            child: Row(
              children: [
                // Container(
                //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                //   height: 50,
                //   width: 50,
                //   //
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(25),
                //       color: Colors.transparent.withOpacity(0.2),
                //       image: DecorationImage(image: NetworkImage(checkoutController.storeDetailController.storeDetailsObj.value.storeProfileImagePath))),
                // ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                    imageUrl: checkoutController.storeDetailController.storeDetailsObj.value.storeProfileImagePath,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.transparent.withOpacity(0.2),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'vanueName'.tr,
                      style: TextStyle(fontFamily: AppFont.regular),
                    ),
                    SizedBox(
                      width: Get.width * 0.65,
                      child: Text(
                        checkoutController.storeDetailController.storeDetailsObj.value.storeName,
                        style: TextStyle(fontFamily: AppFont.bold, color: Color(0xFFe3a9a9), fontSize: 15),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: checkoutController.arrSelectedServices.length,
                itemBuilder: (context, ind) {
                  var currentObj = checkoutController.arrSelectedServices[ind];
                  return categories(currentObj, context);
                }),
          ),
          totalBokingContainer(),
          SizedBox(
            height: 20,
          ),
          cancellationPolicy(),
          SizedBox(
            height: 20,
          )
        ]));
  }

// TotalBooking Container
  Container totalBokingContainer() {
    return Container(
      height: 55,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(AppColor.logoBgColor),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(text: 'totalBooking'.tr, style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: AppFont.bold), children: <TextSpan>[
            TextSpan(
              text: '  ${checkoutController.totalPrice.toStringAsFixed(2)}' + appStaticPriceSymbol,
              style: TextStyle(color: Color(0xFFdb8a8a), fontSize: 18),
            )
          ]),
        ),
      ),
    );
  }

//cancellationPolicy
  Row cancellationPolicy() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          height: 40,
          width: 35,
          child: Image.asset(
            AssestPath.detailScreen + "CancellationPolicy.png",
            fit: BoxFit.fill,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'cancellationPolicy'.tr,
              style: TextStyle(
                fontFamily: AppFont.bold,
              ),
            ),
            InkWell(
              onTap: () {
                // Get.to();
              },
              child: Text(
                'showPolicy'.tr,
                style: TextStyle(color: Color(0xFFdb8a8a), fontFamily: AppFont.regular, fontSize: 12),
              ),
            ),
          ],
        )
      ],
    );
  }

  Column categories(SelectedServiceModel currentObj, BuildContext context) {
    List<String> nameList = currentObj.empname.split(' ');
    String name = '';
    if (nameList.length == 2) {
      name = nameList.first[0].toUpperCase() + nameList.last[0].toUpperCase();
    } else {
      name = nameList.first[0].toUpperCase() + nameList.first[1].toUpperCase();
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFe8e8ec)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    padding: EdgeInsets.all(10),
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFe3a9a9),
                    ),
                    child: SvgPicture.network(
                      currentObj.categoryImagePath,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentObj.name,
                    style: TextStyle(fontFamily: AppFont.bold, fontSize: 18),
                  ),
                  Spacer(),
                  dropDownButton(),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: checkoutController.servcesIcon.value,
                child: Container(
                    child: Container(
                  margin: EdgeInsets.fromLTRB(0, 70, 0, 20),
                  child: Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.all(15),
                        height: 70,
                        width: Get.width,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFe8e8ec)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                              height: 50,
                              width: 50,
                              child: currentObj.empimage == 'https://www.reserved4you.de/storage/app/public/default/default-user.png' ||
                                      currentObj.empimage == null ||
                                      currentObj.empimage == ''
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFdb8a8a),
                                          ),
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: currentObj.empimage,
                                      placeholder: (context, url) => Image.asset("assets/images/store_default.png"),
                                      errorWidget: (context, url, error) => Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Color(AppColor.scaffoldbgcolor),
                                          image: DecorationImage(image: AssetImage("assets/images/defaultuser.png")),
                                        ),
                                      ),
                                      imageBuilder: (context, imageProvider) => Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Color(AppColor.scaffoldbgcolor),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentObj.empname,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: AppFont.semiBold),
                                ),
                                Text(
                                  currentObj.appodatetemp + " - " + currentObj.appotime,
                                  style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: AppFont.semiBold),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: currentObj.servicecategory.length,
                          itemBuilder: (context, ind) {
                            var serviceObj = currentObj.servicecategory[ind];
                            return categoriesItem(serviceObj, context);
                          }),
                    ],
                  ),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Categories Items
  Container categoriesItem(Servicecategory obj, BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              obj.serviceName,
              style: TextStyle(fontSize: 16, fontFamily: AppFont.bold),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: obj.serviceVariant.length,
                itemBuilder: (context, ind) {
                  var vObj = obj.serviceVariant[ind];
                  return categoriesvariant(vObj, context);
                }),
          ),
        ],
      ),
    );
  }

// Categories Variant
  Widget categoriesvariant(SelectedServiceVariant currentObj, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width * 0.65,
                  child: Text(
                    currentObj.description == null ? " - " : currentObj.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: AppFont.regular, color: Color(0xFF575e67), fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  CommonVariables(context: context).durationToString(int.parse(currentObj.durationOfService)),
                  style: TextStyle(fontFamily: AppFont.regular, color: Colors.grey[400], fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Spacer(),
            Text(
              currentObj.vpricefinal + appStaticPriceSymbol,
              style: TextStyle(fontSize: 15, fontFamily: AppFont.bold),
            ),
          ],
        ),
        Divider()
      ],
    );
  }

//DropDown Button
  Container dropDownButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
      height: 30,
      width: 30,
      child: Obx(
        () => FloatingActionButton(
            heroTag: 'btn2',
            child: checkoutController.servcesIcon.value == false
                ? Icon(
                    Icons.keyboard_arrow_down,
                    size: 25,
                    color: Colors.grey[400],
                  )
                : Icon(
                    Icons.keyboard_arrow_up,
                    size: 25,
                    color: Colors.grey[400],
                  ),
            backgroundColor: Color(AppColor.scaffoldbgcolor),
            elevation: 0,
            onPressed: () {
              checkoutController.servcesIcon.value = !checkoutController.servcesIcon.value;
            }),
      ),
    );
  }
}
