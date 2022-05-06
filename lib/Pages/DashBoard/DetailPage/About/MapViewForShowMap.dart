import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';

// ignore: must_be_immutable
class MapViewForShowMap extends StatelessWidget {
  StoreDetailController _storeDetailController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: googlemap(),
    );
  }

  Widget googlemap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
            double.parse(
                _storeDetailController.storeDetailsObj.value.about.latitude),
            double.parse(
                _storeDetailController.storeDetailsObj.value.about.longitude)),
        zoom: 17,
      ),
      markers: _storeDetailController.markers,

      tiltGesturesEnabled: true,

      myLocationButtonEnabled: false, //right bottom button
    );
  }

  AppBar appbar() {
    return AppBar(
      backgroundColor: Color(AppColor.scaffoldbgcolor),
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          height: 35.0,
          width: 35.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Get.back();
            },
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        _storeDetailController.storeDetailsObj.value.storeName,
        style: TextStyle(
            fontFamily: AppFont.bold, fontSize: 15, color: Colors.black),
      ),
      centerTitle: true,
    );
  }
}
