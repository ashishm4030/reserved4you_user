import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';

import '../StoreDetailController.dart';
import '../StoreDetailsModel.dart';

// ignore: must_be_immutable
class ShowDetailsView extends StatelessWidget {
  StoreDetailController servicesController = Get.put(StoreDetailController());
  ParticularServiceDetails currentObj = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 220,
                    width: Get.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(currentObj.serviceImagePath), fit: BoxFit.fill),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Colors.transparent.withOpacity(0.1)),
                    // Back button And UrlImg Container
                  ),
                  backBtnAndUrlImg(),
                ],
              ),
              // Name And Rating Container
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                height: 120,
                width: Get.width,
                color: Color(AppColor.logoBgColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subCategoriesDetils(),
                    SizedBox(
                      height: 15,
                    ),
                    // Rating Star Widget........
                    ratingStar(),
                  ],
                ),
              ),
              discription(),
            ],
          ),
        ),
      ),
    );
  }

// Back button And UrlImg Container
  Widget backBtnAndUrlImg() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            boxShadow: [const BoxShadow(color: Colors.black12, spreadRadius: 1, offset: Offset(1, 1), blurRadius: 7)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(100)),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: 15,
          ),
          onPressed: () {
            Get.back();
          },
        ));
  }

//Sub Categories Details
  Container subCategoriesDetils() {
    return Container(
      child: Text(
        "${currentObj.serviceName}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );
  }

// Rating Star Widget.......
  Row ratingStar() {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: double.parse(currentObj.avgRating),
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          glowColor: Colors.white,
          ignoreGestures: true,
          itemSize: 30,
          unratedColor: Color(0xFFdadbde),
          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
          itemBuilder: (context, index) {
            return Container(
              height: 20,
              width: 20,
              child: Image.asset(
                AssestPath.homeView + "Star.png",
                height: 18,
                width: 18,
              ),
            );
          },
          onRatingUpdate: (value) {},
        ),
        Container(
          margin: EdgeInsets.only(left: 15),
          height: 30,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFfaba5f),
          ),
          child: Center(
            child: Text(
              "${double.parse(currentObj.avgRating.toString())}",
              style: TextStyle(
                fontFamily: AppFont.semiBold,
                fontSize: 18,
                color: Color(AppColor.scaffoldbgcolor),
              ),
            ),
          ),
        )
      ],
    );
  }

// Discription
  Padding discription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'discription'.tr,
                style: TextStyle(
                  fontFamily: AppFont.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(currentObj.description),
        ],
      ),
    );
  }
}
