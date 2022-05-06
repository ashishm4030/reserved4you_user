import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Helper/commanWidgets.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/ServiceView/ServiceDetailsCell.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import '../../Widget.dart';

class SevicesView extends StatelessWidget {
  StoreDetailController _servicesController = Get.put(StoreDetailController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _servicesController.fabIconNumber.value = false;
      },
      child: Stack(
        children: [
          Container(
            color: Color(AppColor.logoBgColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => viewCategoryListView(),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 200,
              ),
              topDiscountPopilar(),
              allServices(),
            ],
          ),
          Obx(
            () => Column(
              children: [
                //sub - Categories,
                subCategories(),
                Visibility(
                  visible: _servicesController.fabIconNumber.value,
                  child: Container(child: Center(child: dropDownContainer())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget noDataFound(BuildContext context) {
    return Obx(() => CommanWidget(context: context).showlolder(isshowDilog: _servicesController.isOpenForService.value));
  }

  Widget topDiscountPopilar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _servicesController.arrTopDiscountAndPopluar.length == 0 ? SizedBox() : titelRow('topdiscountPopuler'.tr),
        Obx(
          () => Container(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _servicesController.arrTopDiscountAndPopluar.length,
                itemBuilder: (context, ind) {
                  var currentObj = _servicesController.arrTopDiscountAndPopluar[ind];
                  return Obx(() => ServiceDetailsCell(
                        isDiscountVisible: currentObj.discount == "0" ? false : true,
                        currentObj: currentObj,
                        selectedDataInd: ind,
                        isForAllService: true,
                      ));
                }),
          ),
        ),
        Obx(
          () => Center(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                _servicesController.arrTopDiscountAndPopluar.length == 0 ? '' : "",
                style: TextStyle(
                  fontFamily: AppFont.semiBold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget allServices() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titelRow('allServices'.tr),
        Obx(
          () => Container(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _servicesController.arrAllServices.length,
                itemBuilder: (context, ind) {
                  var currentObj = _servicesController.arrAllServices[ind];
                  print(currentObj.price);
                  print(currentObj.discount);
                  return ServiceDetailsCell(
                    isDiscountVisible: double.parse(currentObj.discount) == double.parse(currentObj.price) ? false : true,
                    currentObj: currentObj,
                    selectedDataInd: ind,
                    isForAllService: true,
                  );
                }),
          ),
        ),
        Obx(() => Center(
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  _servicesController.arrAllServices.length == 0 ? 'noDataFound'.tr : "",
                  style: TextStyle(
                    fontFamily: AppFont.semiBold,
                  ),
                ),
              ),
            ))
      ],
    );
  }

  //Titel
  Padding titelRow(String text) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
      ),
      child: Text(
        text,
        style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 20),
      ),
    );
  }

  //sub - Categories,
  Widget subCategories() {
    return Center(
        child: Container(
      margin: EdgeInsets.only(top: 135),
      alignment: Alignment.center,
      height: 50,
      width: Get.width * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFdb8a8a),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _servicesController.fabIconNumber.value = !_servicesController.fabIconNumber.value;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              _servicesController.selectedSubCategoryName.value,
              style: TextStyle(
                  color: Color(
                    AppColor.logoBgColor,
                  ),
                  fontFamily: AppFont.regular,
                  fontSize: 16),
            ),
            Spacer(),
            iconButton(),
          ],
        ),
      ),
    ));
  }

  Widget viewCategoryListView() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        //left: 20,
      ),
      child: _servicesController.arrCategory.length == 0
          ? Center(
              child: Container(
                height: 100,
                child: Text(
                  _servicesController.arrAllServices.length == 0 ? 'noDataFound'.tr : "",
                  style: TextStyle(
                    fontFamily: AppFont.semiBold,
                  ),
                ),
              ),
            )
          : Container(
              height: 100,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: _servicesController.arrCategory.length,
                itemBuilder: (context, ind) {
                  var currentObj = _servicesController.arrCategory[ind];
                  return InkWell(
                    onTap: () {
                      _servicesController.selectedCategoryId.value = currentObj.categoryId;
                      _servicesController.selectedIndex.value = ind;
                      _servicesController.getCategoryWiseSubCategory();
                      _servicesController.getServiceAccrdingtoCatSubCat();
                    },
                    child: Obx(() => HomeUnits().categoryShell(
                        imgurl: currentObj.categoryImagePath, categoryName: currentObj.categoryName, isSelected: ind == _servicesController.selectedIndex.value ? true : false)),
                  );
                },
              ),
            ),
    );
  }

  // IconButton
  Container iconButton() {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: _servicesController.fabIconNumber.value == false
          ? Icon(Icons.keyboard_arrow_up, color: Color(AppColor.logoBgColor), size: 35)
          : Icon(Icons.keyboard_arrow_down, color: Color(AppColor.logoBgColor), size: 35),
    );
  }

  Container dropDownContainer() {
    return Container(
      // margin: EdgeInsets.only(top: 185),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
      width: Get.width * 0.90,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Color(0xFFffffff), border: Border.all(color: Colors.grey, width: 0.5)),
      child: Container(
        //height: 200,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _servicesController.arrCategoryWiseSubCategory.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, ind) {
              var currentObj = _servicesController.arrCategoryWiseSubCategory[ind];
              return InkWell(
                onTap: () {
                  _servicesController.selectedSubCategoryId.value = currentObj.id.toString();

                  _servicesController.selectedSubCategoryName.value = currentObj.name;
                  _servicesController.fabIconNumber.value = !_servicesController.fabIconNumber.value;
                  _servicesController.getServiceAccrdingtoCatSubCat();
                },
                child: buildTextFieldContainer(categoriesname: currentObj.name),
              );
            }),
      ),
    );
  }

  Column buildTextFieldContainer({String categoriesname, bool isSelected}) {
    return Column(
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(AppColor.logoBgColor),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "$categoriesname",
                style: TextStyle(color: Color(0xFFe19d9c), fontFamily: AppFont.regular, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
