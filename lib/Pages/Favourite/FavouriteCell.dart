import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/preferences.dart';
import 'package:reserve_for_you_user/Helper/url.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardController.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardModel.dart';
import 'package:reserve_for_you_user/Pages/Favourite/FavController.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class FavouriteCell extends StatelessWidget {
  FavouriteCell({
    Key key,
    this.urlimg,
    this.storename,
    this.isfavourite,
    this.discount,
    this.avgrating,
    this.totalfeedback,
    this.isvalue,
    this.storeaddress,
    this.categoryid,
    this.storecategory,
    this.storeId,
    this.isFromFav,
    this.controllerFav,
    this.controller,
    this.currentInd,
    this.discountValue,
    this.storeGallery,
  }) : super(key: key);

  var urlimg;
  var storename;
  bool isfavourite;
  bool discount;
  var avgrating;
  var totalfeedback;
  var isvalue;
  var storeaddress;
  var categoryid;
  var storeId;
  int currentInd;
  List<StoreCategory> storecategory;
  var isFromFav = false;
  FavouriteController controllerFav;
  DashBoardController controller;
  var discountValue;
  var width = Get.width - 30;
  var storeGallery = <StoreGallery>[];
  PageController pagecontroll = new PageController(viewportFraction: 1, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed("/storeDetailsView", arguments: storeId);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            storeGallery.length > 0 ? multipleImageContainer() : gridViewContainer(""),
            gridViewContainerRows(context),
          ]),
          favouriteShellDetailPage(context)
        ],
      ),
    );
  }

  Widget multipleImageContainer() {
    return Container(
      height: 230,
      child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pagecontroll,
          itemCount: storeGallery.length,
          itemBuilder: (context, ind) {
            return gridViewContainer(storeGallery[ind].storeGalleryImagePath);
          }),
    );
  }

  Widget gridViewContainer(String img) {
    // GridView Container
    return Container(
      height: 230,
      width: Get.width - 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: CachedNetworkImage(
        imageUrl: img,
        placeholder: (context, url) => Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/store_default.png",
            ),
          ),
        )),
        errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/store_default.png",
            ),
          ),
        )),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================================================================================//
// GridView Container Widget
  Padding gridViewContainerRows(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            discountConAndLikeButton(),
            SizedBox(
              height: 140,
            ),
            Visibility(
              visible: storeGallery.length > 1 ? true : false,
              child: backAndForwardIndicators(),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

// Discount Container And LikeButton
  Row discountConAndLikeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: discount,
          /*// discount container*/ child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xFFFABA5F),
            ),
            child: Center(
              child: Text('%', //+ discountValue,
                  style: TextStyle(color: Colors.white, fontFamily: AppFont.bold, fontSize: 14)),
            ),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          child: FloatingActionButton(
            onPressed: () async {
              var isLogin = await Preferences.preferences.getBool(key: PrefernceKey.isUserLogin, defValue: false);

              if (isLogin) {
                var url = isfavourite == true ? ApiUrl.removestorefavorites : ApiUrl.addstorefavorites;
                isFromFav ? controllerFav.doFavouriteFromServer(storeId, url) : controller.doFavouriteFromServer(storeId, url, currentInd);
              } else {
                Get.toNamed("/login", arguments: true);
              }
            },
            backgroundColor: Color(AppColor.scaffoldbgcolor),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                isfavourite ? AssestPath.favourite + 'Favourite.png' : AssestPath.favourite + 'unFavourite.png',
              ),
            ),
          ),
        )
      ],
    );
  }

//  Back And Forward Indicators Row
  Row backAndForwardIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (pagecontroll.page != 0) {
              pagecontroll.previousPage(duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black45),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        bottomPager(),
        GestureDetector(
          onTap: () {
            if (pagecontroll.page != storeGallery.length - 1) {
              pagecontroll.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black45),
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Column favouriteShellDetailPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        raetingAndReviewRow(context),
        SizedBox(
          height: 15,
        ),
        // Shop Name Row
        shopNameRow(),
        SizedBox(
          height: 10,
        ),
        // AddressRow
        addressRow(),
        SizedBox(
          height: 8,
        ),
        cosmaticsItemsName(),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 38,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: storecategory.length,
              itemBuilder: (context, ind) {
                return listViewBuilderContainer(storecategory[ind].name);
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Color(0xFFcfd1d4),
        )
      ],
    );
  }

  // Rateting And Review Row
  Widget raetingAndReviewRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFFfaba5f),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 3,
                    right: 5,
                  ),
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xFFffffff),
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: Color(0xFFfaba5f),
                    size: 20,
                  ),
                ),
                Text(
                  avgrating,
                  style: TextStyle(color: Color(0xFFffffff), fontFamily: AppFont.regular, fontSize: 13),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '(' + '$totalfeedback ' + "${totalfeedback == 1 ? 'rating'.tr : 'reviewes'.tr}" + ')',
            style: TextStyle(color: Color(0xFFa3a6ab), fontFamily: AppFont.regular, fontSize: 12),
          ),
          Spacer(),
          Text(
            isvalue,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: AppFont.regular,
            ),
          ),
        ],
      ),
    );
  }

// Shop Name Row
  Widget shopNameRow() {
    return Text(storename, style: TextStyle(color: Color(0xFF101928), fontSize: 18, fontFamily: AppFont.medium));
  }

// AddressRow
  Row addressRow() {
    return Row(children: [
      Image.asset(
        AssestPath.favourite + 'pin.png',
        height: 18,
        color: Color(0xFF636972),
      ),
      SizedBox(
        width: 5,
      ),
      Expanded(
        child: Text(storeaddress,
            style: TextStyle(
              color: Color(0xFF5b626c),
              fontFamily: AppFont.regular,
              fontSize: 13,
            )),
      ),
    ]);
  }

  Row cosmaticsItemsName() {
    return Row(
      children: [
        Image.asset(
          AssestPath.favourite + 'Cosmet.png',
          height: 18,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          categoryid,
          style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 13),
        )
      ],
    );
  }

  Container listViewBuilderContainer(text) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      height: 38,
      padding: EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFf4f6f7)),
      child: Text(
        '$text',
        style: TextStyle(fontFamily: AppFont.regular, color: Color(0xFF6c717b), fontSize: 13),
      ),
    );
  }

  Widget bottomPager() {
    return Container(
      height: 20,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: SmoothPageIndicator(
          controller: pagecontroll,
          count: storeGallery.length,
          effect: ScrollingDotsEffect(
            activeStrokeWidth: 1.3,
            activeDotScale: 1.6,
            dotHeight: 8,
            dotWidth: 8,
            fixedCenter: true,
            dotColor: Color(0xFFcfccc9),
            activeDotColor: Colors.white,
            spacing: 8,
          )),
    );
  }
}
