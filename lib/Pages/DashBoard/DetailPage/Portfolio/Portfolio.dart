import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsModel.dart';

import '../StoreDetailController.dart';

// ignore: must_be_immutable
class PortFolioView extends StatelessWidget {
  StoreDetailController _storeDetailController = Get.put(StoreDetailController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      width: Get.width,
      child: _storeDetailController.storeDetailsObj.value.storeGalleryOriginel.length == 0
          ? Container(
              alignment: Alignment.center,
              child: Text(
                'noDataFound'.tr,
                style: TextStyle(
                  fontFamily: AppFont.bold,
                  fontSize: 15,
                ),
              ),
            )
          : gridViewForPortfolio(),
    );
  }

  Widget gridViewForPortfolio() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _storeDetailController.storeDetailsObj.value.storeGalleryOriginel.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        var currentObj = _storeDetailController.storeDetailsObj.value.storeGalleryOriginel[index];
        return InkWell(
          onTap: () async {
            // if (await Permission.photos.request().isGranted) {}

            // ignore: deprecated_member_use
            var arr = List<String>();
            for (StoreGalleryPortfolio temp in _storeDetailController.storeDetailsObj.value.storeGalleryOriginel) {
              arr.add(temp.storeGalleryImagePath);
            }
            /*ImageViewer.showImageSlider(
                images: arr,
                startingPosition: index,
              );*/
          },
          child: categoryShell(index),
        );
      },
    );
  }

  Widget categoryShell(int index) {
    return Container(
        height: 100,
        width: 100,
        child: InkWell(
          onTap: () {
            //_storeDetailController.pageController.jumpToPage(index);
            _storeDetailController.pageController = PageController(initialPage: index);
            Get.to(() => ImageViewPhotos());
          },
          child: CachedNetworkImage(
            imageUrl: _storeDetailController.storeDetailsObj.value.storeGalleryOriginel[index].storeGalleryImagePath,
            placeholder: (context, url) => Image.asset("assets/images/store_default.png"),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/store_default.png",
              fit: BoxFit.cover,
            ),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.transparent.withOpacity(0.2)),
            ),
          ),
        ));
  }
}

class ImageViewPhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreDetailController _storeDetailController = Get.put(StoreDetailController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 250,
                child: PageView.builder(
                  itemCount: _storeDetailController.storeDetailsObj.value.storeGalleryOriginel.length,
                  controller: _storeDetailController.pageController,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(_storeDetailController.storeDetailsObj.value.storeGalleryOriginel[index].storeGalleryImagePath), fit: BoxFit.cover)),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Container(
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
