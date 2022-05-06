import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/Favourite/FavController.dart';
import 'package:reserve_for_you_user/Pages/Favourite/FavouriteCell.dart';

class FavouriteView extends StatefulWidget {
  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  FavouriteController _favouriteViewController = Get.put(FavouriteController());

  @override
  void initState() {
    super.initState();
    _favouriteViewController.checkIfLoginOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
        controller: _favouriteViewController.refreshController,
        enablePullDown: true,
        header: ClassicHeader(
          completeText: 'refreshCompleted'.tr,
          releaseText: 'releaseToRefresh'.tr,
          idleText: 'pullDownRefresh'.tr,
        ),
        onRefresh: () async {
          _favouriteViewController.getFavData();
        },
        child: Column(
          children: [
            buildLogo(context),
            Obx(
              () => _favouriteViewController.isLoader == true ? CircularProgressIndicator()
                  : _favouriteViewController.arrFavStoreList.isBlank
                  ? Container(
                      padding: EdgeInsets.all(10),
                      height: Get.height * 0.7,
                      child: Center(
                        child: Text(
                          'nostore'.tr,
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: AppFont.bold,
                              color: Colors.black),
                        ),
                      ),
                    )
                  : Expanded(
                      child: bottomStoreList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildLogo(
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 0, top: 0, bottom: 20),
      padding: EdgeInsets.only(
        left: 20,
      ),
      width: double.infinity,
      color: Color(AppColor.logoBgColor),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AssestPath.favourite + 'Logo_Home.png',
                height: 20,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "favouriteCollection".tr,
                style: TextStyle(fontSize: 22, fontFamily: AppFont.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomStoreList() {
    return Container(
      child: ListView.builder(
          itemCount: _favouriteViewController.arrFavStoreList == null
              ? 0
              : _favouriteViewController.arrFavStoreList.length,
          itemBuilder: (context, ind) {
            var currentObj = _favouriteViewController.arrFavStoreList[ind];
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: FavouriteCell(
                urlimg: currentObj.storeBannerImagePath,
                discount: currentObj.discountFlage,
                isfavourite: true,
                avgrating: currentObj.avgRating,
                totalfeedback: currentObj.totalFeedback,
                isvalue: currentObj.isValue,
                storename: currentObj.storeName,
                categoryid: currentObj.categoryName,
                storeaddress: currentObj.storeAddress,
                storecategory: currentObj.storeCategory,
                storeId: currentObj.storeid.toString(),
                discountValue: currentObj.discount,
                isFromFav: true,
                controllerFav: _favouriteViewController,
                currentInd: ind,
                storeGallery: currentObj.storeGallery,
              ),
            );
          }),
    );
  }
}
