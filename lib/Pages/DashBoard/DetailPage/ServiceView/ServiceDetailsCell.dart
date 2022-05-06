import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import '../StoreDetailController.dart';
import '../StoreDetailsModel.dart';

// ignore: must_be_immutable
class ServiceDetailsCell extends StatelessWidget {
  ServiceDetailsCell({
    Key key,
    this.currentObj,
    this.isDiscountVisible,
    this.selectedDataInd,
    this.isForAllService,
  }) : super(key: key);

  var currentObj = ServiceDetails();
  bool isDiscountVisible;
  int selectedDataInd;
  bool isForAllService = false;
  var discountType = "";

  StoreDetailController _servicesController = Get.put(StoreDetailController());

  @override
  Widget build(BuildContext context) {
    discountType = currentObj.discountType;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              urlImageDiscountContainer(),
              SizedBox(
                height: 10,
              ),
              titleAndUpDownButton(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    currentObj.dureationOfServiceNew,
                    style: TextStyle(color: Color(0xFFa2a6ab), fontFamily: AppFont.regular),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => showDetailsRow(),
              ),
              SizedBox(height: 10),
              Obx(
                () => Visibility(
                  visible: isForAllService ? currentObj.isvarientMenuOpenForAllService.value : currentObj.isvarientMenuOpen.value,
                  child: dropDownContainer(context),
                ),
              ),
              Divider(
                height: 30,
                color: Colors.grey,
              ),
            ],
          ),
        )
      ],
    );
  }

  Row titleAndUpDownButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 280,
          child: Text(
            "${currentObj.serviceName}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
        ),
        Visibility(
          visible: currentObj.serviceVariant.length > 1 ? true : false,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xFFe8e8ec)),
            child: Center(
              child: Obx(() => iconButton()),
            ),
          ),
        ),
      ],
    );
  }

  // IconButton
  Widget iconButton() {
    return IconButton(
        icon: ((isForAllService == false && currentObj.isvarientMenuOpen.value) || (isForAllService == true && currentObj.isvarientMenuOpenForAllService.value))
            ? Icon(Icons.keyboard_arrow_up, size: 25)
            : Icon(Icons.keyboard_arrow_down, size: 25),
        onPressed: () {
          _servicesController.clickToOpenVarientDialogFromDiscountPopuler(isForAllService: isForAllService, selectedIndex: selectedDataInd);
        });
  }

  // Process Implement Time
  Row processImplementTime(String obj) {
    return Row(
      children: [
        Text(
          "${obj} min",
          style: TextStyle(color: Color(0xFFa2a6ab)),
        )
      ],
    );
  }

  // UrlImage And Discount Container
  Stack urlImageDiscountContainer() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 180,
          width: Get.width,
          child: CachedNetworkImage(
            imageUrl: currentObj.serviceImagePath,
            placeholder: (context, url) => Image.asset("assets/images/store_default.png"),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/store_default.png",
              fit: BoxFit.cover,
            ),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        currentObj.discount != '0'
            ? Visibility(
                visible: isDiscountVisible,
                child: Container(
                  margin: EdgeInsets.only(top: 35, left: 15),
                  height: 30,
                  width: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color: Color(0xFFFABA5F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "${currentObj.discount}%",
                      style: TextStyle(
                          fontFamily: AppFont.bold,
                          color: Color(
                            AppColor.scaffoldbgcolor,
                          ),
                          fontSize: 16),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  // TextButton And Price
  Row showDetailsRow() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              _servicesController.getparticularSergviceDescription(serviceid: currentObj.id.toString());
            },
            child: Text(
              'shoeDetail'.tr,
              style: TextStyle(
                  color: Color(
                    0xFFdb8a8a,
                  ),
                  fontFamily: AppFont.regular),
            )),
        Spacer(),
        Text(
          currentObj.serviceVariant.length > 1
              ? "${'from'.tr} ${currentObj.fromPrice}" + appStaticPriceSymbol
              : "${currentObj.serviceVariant.first.finalPriceVariant}" + appStaticPriceSymbol,
          style: TextStyle(
            fontFamily: AppFont.regular,
            fontSize: 13,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Visibility(
          visible: double.parse(currentObj.discount) == 0 ? false : true,
          child: Text(
            "${currentObj.serviceVariant.first.price}" + appStaticPriceSymbol,
            style: TextStyle(
              fontFamily: AppFont.regular,
              decoration: TextDecoration.lineThrough,
              color: Color(0xFF848990),
              fontSize: 13,
            ),
          ),
        ),
        Visibility(
          visible: currentObj.serviceVariant.length > 1 ? false : true,
          child: InkWell(
            onTap: () {
              _servicesController.clickToSelectServiceWithoutVarient(selectedIndex: selectedDataInd, isForAllService: isForAllService);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              height: 30,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentObj.serviceVariant.first.tempselectflag.value ? Color(0xFFdb8a8a) : Colors.white,
                  border: Border.all(color: Color(0xFFdb8a8a))),
              child: Center(
                child: Text(
                  currentObj.serviceVariant.first.tempselectflag.value ? 'selected'.tr : 'select'.tr,
                  style: TextStyle(
                    color: currentObj.serviceVariant.first.tempselectflag.value ? Colors.white : Color(0xFFdb8a8a),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget dropDownContainer(BuildContext context) {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: currentObj.serviceVariant.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, ind) {
            var varientObj = currentObj.serviceVariant[ind];

            return Column(
              children: [
                Obx(
                  () => selectCategoris(varientObj, context, ind),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          }),
    );
  }

  Container selectCategoris(ServiceVariant obj, BuildContext context, int selectedIndex) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      width: Get.width * 0.90,
      height: 73,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFf9f9fb),
      ),
      child: Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width * 0.4,
                  child: Text(
                    obj.description,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: AppFont.regular, fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                processImplementTime(obj.durationOfService),
              ],
            ),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${obj.finalPriceVariant}" + appStaticPriceSymbol + "  ",
                style: TextStyle(
                  fontFamily: AppFont.semiBold,
                ),
              ),
              obj.finalPriceVariant == obj.price
                  ? SizedBox()
                  : Text(
                      "${obj.price}" + appStaticPriceSymbol,
                      style: TextStyle(
                        fontFamily: AppFont.regular,
                        decoration: TextDecoration.lineThrough,
                        color: Color(0xFF848990),
                      ),
                    ),
            ],
          ),
          InkWell(
            onTap: () {
              _servicesController.clickToSelectServiceWithVarient(
                isForAllService: isForAllService,
                selectedIndex: selectedDataInd,
                selectedVarientInd: selectedIndex,
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              height: 30,
              width: 73,
              decoration: BoxDecoration(
                  color: obj.tempselectflag.value ? Color(0xFFdb8a8a) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xFFdb8a8a))),
              child: Center(
                child: Text(
                  obj.tempselectflag.value ? 'selected'.tr : 'select'.tr,
                  style: TextStyle(
                    color: obj.tempselectflag.value ? Colors.white : Color(0xFFdb8a8a),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
