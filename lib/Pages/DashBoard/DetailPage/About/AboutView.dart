import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailController.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsModel.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: unused_import
import 'ExpertReviews/StylistExpertReview.dart';

//========= Tab View ============

// ignore: must_be_immutable
class AboutViewPage extends StatefulWidget {
  @override
  State<AboutViewPage> createState() => _AboutViewPageState();
}

class _AboutViewPageState extends State<AboutViewPage> {
  StoreDetailController _storeDetailController = Get.find();
  String firstHalf;
  String secondHalf;

  bool flag = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_storeDetailController.storeDetailsObj.value.storeDescription.length > 100) {
      firstHalf = _storeDetailController.storeDetailsObj.value.storeDescription.substring(0, 100);
      secondHalf = _storeDetailController.storeDetailsObj.value.storeDescription.substring(100, _storeDetailController.storeDetailsObj.value.storeDescription.length);
    } else {
      firstHalf = _storeDetailController.storeDetailsObj.value.storeDescription;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          aboutView(),
          description(),
          advantages(),
          stylistExpert(),
          publicTransport(),
          location(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget aboutView() {
    return Visibility(
      visible: _storeDetailController.storeDetailsObj.value.about.specifics.length != 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        'specifics'.tr,
                        style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 19),
                      ),
                    ),
                    gridViewContainerForSpecifics(),
                    SizedBox(height: 8),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget gridViewContainerForSpecifics() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(00, 18, 0, 0),
      child: Container(
        height: 35 * _storeDetailController.storeDetailsObj.value.about.specifics.length.toDouble(),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0, mainAxisExtent: 50),
            itemCount: _storeDetailController.storeDetailsObj.value.about.specifics.length,
            itemBuilder: (context, ind) {
              var currentObj = _storeDetailController.storeDetailsObj.value.about.specifics[ind];
              return Container(
                //height: 35,
                //width: 115,
                decoration: BoxDecoration(color: Color(AppColor.secondColour), borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                        child: Container(margin: EdgeInsets.all(8), child: SvgPicture.network(currentObj.specificsImagePath)),
                      ),
                      SizedBox(width: 3),
                      Container(
                        width: (Get.width / 2) - 65,
                        child: Text(
                          currentObj.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, fontFamily: AppFont.medium),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget description({htmlText}) {
    return Container(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'discription'.tr,
              style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 18),
            ),
            // SizedBox(height: 10),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child:
                        secondHalf.isEmpty
                            ? Html(
                                shrinkWrap: true,
                                data: firstHalf,
                              )
                            : Html(
                                shrinkWrap: true,
                                data: flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                              ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Text(
                                flag ? 'readMore'.tr : 'readLess'.tr,
                                style: TextStyle(
                                  color: Color(0xFFdd9190),
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  flag = !flag;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Color(0xFFdadcdf),
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget advantages() {
    return Visibility(
      visible: _storeDetailController.storeDetailsObj.value.about.advantages.length != 0,
      child: Container(
        height: _storeDetailController.storeDetailsObj.value.about.advantages.length == 0 ? 100 : 280,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'advantages'.tr,
                style: TextStyle(fontSize: 18, fontFamily: AppFont.semiBold),
              ),
              listViewBuilderForAdvanctages(),
              Divider(
                color: Color(0xFFdadcdf),
                thickness: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewBuilderForAdvanctages() {
    return Container(
      height: 220,
      child: ListView.builder(
          itemCount: _storeDetailController.storeDetailsObj.value.about.advantages.length,
          // itemExtent: 200,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, ind) {
            var currentObj = _storeDetailController.storeDetailsObj.value.about.advantages[ind];
            print(currentObj.storeAdvantageImagePath);
            return Row(
              children: [
                Container(
                  height: 210,
                  width: 290,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Color(AppColor.profileColour), offset: Offset(3, 5), blurRadius: 8, spreadRadius: 2)],
                      color: Color(AppColor.backColour)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          // decoration: BoxDecoration(
                          //     color: Color(AppColor.firstColour),
                          //     borderRadius: BorderRadius.circular(22),
                          //     border: Border.all(color: Colors.white, width: 2),
                          //     boxShadow: [BoxShadow(blurRadius: 6, spreadRadius: -3, offset: Offset(1, 4))]),
                          child: Container(
                            margin: EdgeInsets.all(11),
                            child: SvgPicture.network(
                              currentObj.storeAdvantageImagePath,
                              fit: BoxFit.cover,
                              // color: Colors.white,
                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentObj.title,
                          style: TextStyle(fontFamily: AppFont.medium, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          currentObj.description,
                          // overflow: TextOverflow.visible,
                          // maxLines: 5,
                          style: TextStyle(color: Color(0xFF81858e), fontSize: 12, fontFamily: AppFont.light),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            );
          }),
    );
  }

  Widget stylistExpert() {
    return Visibility(
      visible: (_storeDetailController.storeDetailsObj.value.about.ourServiceExpert.length == 0 && _storeDetailController.txtStylistSearch.text.isEmpty) ? false : true,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Container(
          height: 300,
          width: Get.width,
          child: Column(
            children: [
              /*Stylist expert row*/ Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'stylistExpert'.tr,
                    style: TextStyle(fontSize: 18, fontFamily: AppFont.semiBold),
                  ),
                  InkWell(
                    onTap: () {
                      if (_storeDetailController.storeDetailsObj.value.about.ourServiceExpert.first.id > 0)
                        Get.toNamed('/stylistExpertReview',
                            arguments: [_storeDetailController.selectedStoreId, _storeDetailController.storeDetailsObj.value.about.ourServiceExpert.first.id]);
                    },
                    child: Text('employeeReviews'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppFont.regular,
                          color: Color(0xFFdb8a8a),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              /*textfeild*/ Container(
                height: 45,
                width: Get.width,
                decoration: BoxDecoration(color: Color(AppColor.thirdColour), borderRadius: BorderRadius.circular(10)),
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: TextFormField(
                    controller: _storeDetailController.txtStylistSearch,
                    onChanged: (value) {
                      if (value.length > 1) {
                        _storeDetailController.getSearchData(searchtext: value);
                      } else if (value.isEmpty) {
                        _storeDetailController.getSearchData(searchtext: "");
                      }
                    },
                    decoration: InputDecoration(
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Image.asset(
                            AssestPath.homeView + 'SearchWhite.png',
                            height: 20,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: InputBorder.none,
                        labelText: 'findByEmployeeNameShort'.tr,
                        labelStyle: TextStyle(fontFamily: AppFont.light, fontSize: 17)),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              /*List view for expert*/
              Container(
                height: 200,
                width: Get.width,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _storeDetailController.storeDetailsObj.value.about.ourServiceExpert.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, ind) {
                      var currentObj = _storeDetailController.storeDetailsObj.value.about.ourServiceExpert[ind];
                      List<String> nameList = currentObj.empName.split(' ');
                      String name = '';
                      if (nameList.length == 2) {
                        name = nameList.first[0].toUpperCase() + nameList.last[0].toUpperCase();
                      } else {
                        name = nameList.first[0].toUpperCase() + nameList.first[1].toUpperCase();
                      }

                      return Align(
                          widthFactor: ind == 0 ? null : 0.8,
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/stylistExpertReview', arguments: [_storeDetailController.selectedStoreId, currentObj.id]);
                                    },
                                    child: currentObj.empImagePath == null
                                        ? Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(60),
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFdb8a8a),
                                                ),
                                              ),
                                            ),
                                          )
                                        : /*Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(60),
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.white,
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      currentObj.empImagePath,
                                                    ),
                                                    fit: BoxFit.cover)),
                                          )*/
                                        Container(
                                            height: 120,
                                            width: 120,
                                            child: CachedNetworkImage(
                                              imageUrl: currentObj.empImagePath,
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(60),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Colors.white,
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  Center(
                                    widthFactor: 2.5,
                                    child: ratting("${double.parse(currentObj.avgRating)}"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  currentObj.empName,
                                  maxLines: 1,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontFamily: AppFont.regular, fontSize: 15),
                                ),
                              ),
                            ],
                          ));
                    }),
              ),
              Divider(
                height: 1,
                color: Colors.black38,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ratting(String avgrating) {
    return Container(
      height: 30,
      width: 50,
      margin: EdgeInsets.only(
        top: 100,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xFFfaba5f),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 20,
            width: 20,
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
            style: TextStyle(color: Color(0xFFffffff), fontFamily: AppFont.regular, fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget publicTransport() {
    return Visibility(
      visible: _storeDetailController.storeDetailsObj.value.about.publicTransportation.length != 0,
      child: Container(
        height: 160,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'publicTransportation'.tr,
                style: TextStyle(fontSize: 18, fontFamily: AppFont.semiBold),
              ),
              SizedBox(height: 13),
              Text(
                'nearestSpot'.tr,
                style: TextStyle(fontSize: 15, fontFamily: AppFont.light, color: Color(0xFF858990)),
              ),
              SizedBox(height: 10),
              Container(
                height: 60,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _storeDetailController.storeDetailsObj.value.about.publicTransportation.length,
                    itemBuilder: (context, ind) {
                      var currentObj = _storeDetailController.storeDetailsObj.value.about.publicTransportation[ind];
                      return publicTranspotationCell(currentObj);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget publicTranspotationCell(PublicTransportation currentObj) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Container(
        height: 55,
        //width: 230,
        decoration: BoxDecoration(color: Color(AppColor.secondColour), borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(23), color: Color(AppColor.firstColour)),
                      child: Container(
                        child: SvgPicture.network(
                          currentObj.transportationImagePath,
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.all(8),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      currentObj.transportationNo,
                      style: TextStyle(color: Color(AppColor.firstColour), fontFamily: AppFont.medium, fontSize: 16),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Text(
                currentObj.title,
                style: TextStyle(fontFamily: AppFont.medium),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget location() {
    return Container(
      color: Color(0xFFf9f9fb),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'locationByMap'.tr,
              style: TextStyle(fontFamily: AppFont.semiBold, fontSize: 18),
            ),
            SizedBox(height: 18),
            /*Google map*/ Container(
              height: 200,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: googlemap(_storeDetailController.storeDetailsObj.value.about.locationbymap),
            ),
            SizedBox(height: 12),
            /*Disctrict*/ Container(
              height: 70,
              width: Get.width,
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    child: Container(
                      child: Image.asset(AssestPath.detailScreen + "Districs.png"),
                      margin: EdgeInsets.all(10),
                    ),
                    decoration: BoxDecoration(color: Color(AppColor.backColour), borderRadius: BorderRadius.circular(22)),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'district'.tr,
                            style: TextStyle(fontSize: 17, fontFamily: AppFont.semiBold),
                          ),
                          Text(
                            _storeDetailController.storeDetailsObj.value.about.district == null ? "-" : _storeDetailController.storeDetailsObj.value.about.district,
                            style: TextStyle(fontSize: 14, fontFamily: AppFont.regular, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Divider(
              height: 1,
              color: Colors.black38,
              thickness: 1,
            ),
            SizedBox(height: 5),
            /*Opening Hour*/ Container(
              height: 70,
              width: Get.width,
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    child: Container(
                      child: Image.asset(AssestPath.detailScreen + "Opening Hours.png"),
                      margin: EdgeInsets.all(10),
                    ),
                    decoration: BoxDecoration(color: Color(AppColor.backColour), borderRadius: BorderRadius.circular(22)),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'openingHours'.tr,
                            style: TextStyle(fontSize: 17, fontFamily: AppFont.semiBold),
                          ),
                          Text(
                            _storeDetailController.currentWeekDayObj.isOff == "on"
                                ? "${_storeDetailController.weekday + " " + " - "}"
                                : "${_storeDetailController.weekday + " " + _storeDetailController.currentTimeStlot}",
                            style: TextStyle(fontSize: 14, fontFamily: AppFont.regular, color: Color(AppColor.firstColour)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            /*Opening Hour List*/ Container(
              //height: 270,
              width: Get.width,
              padding: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(color: Color(AppColor.backColour), borderRadius: BorderRadius.circular(20)),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _storeDetailController.storeDetailsObj.value.about.openingHours.length,
                itemBuilder: (contextl, ind) {
                  var currentobj = _storeDetailController.storeDetailsObj.value.about.openingHours[ind];
                  bool highLite = DateTime.now().weekday == (ind + 1);
                  return Container(
                    decoration: BoxDecoration(color: highLite ? Colors.red.withOpacity(0.4) : Colors.white, borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                    padding: EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          getDayName(currentobj.day),
                          style: TextStyle(
                            fontFamily: currentobj.day.contains(_storeDetailController.weekday) ? AppFont.medium : AppFont.light,
                            fontSize: 12,
                            color: currentobj.day.contains(_storeDetailController.weekday) ? Colors.black : Color(0xFF70757e),
                          ),
                        ),
                        Spacer(),
                        Text(
                          currentobj.isOff == "on" ? 'storeClose'.tr : "${currentobj.startTime} - ${currentobj.endTime}",
                          style: TextStyle(
                            fontFamily: currentobj.day.contains(_storeDetailController.weekday) ? AppFont.medium : AppFont.light,
                            fontSize: 12,
                            color: currentobj.day.contains(_storeDetailController.weekday) ? Colors.black : Color(0xFF70757e),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            /*Web Home*/ Container(
              width: Get.width,
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    child: Container(
                      child: Image.asset(AssestPath.detailScreen + "Opening Hours.png"),
                      margin: EdgeInsets.all(10),
                    ),
                    decoration: BoxDecoration(color: Color(AppColor.backColour), borderRadius: BorderRadius.circular(22)),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'webHome'.tr,
                            style: TextStyle(fontSize: 18, fontFamily: AppFont.semiBold),
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              String url = _storeDetailController.storeDetailsObj.value.about.homeUrl;
                              launchURL(url);
                            },
                            child: Container(
                              width: Get.width * 0.70,
                              child: Text(
                                _storeDetailController.storeDetailsObj.value.about.homeUrl == null ? "-" : _storeDetailController.storeDetailsObj.value.about.homeUrl,
                                style: TextStyle(fontSize: 14, fontFamily: AppFont.regular, color: Color(AppColor.firstColour), decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String getDayName(String day) {
    if (day == "Monday") {
      return 'monday'.tr;
    } else if (day == "Tuesday") {
      return 'tuesday'.tr;
    } else if (day == "Wednesday") {
      return 'wednesday'.tr;
    } else if (day == "Thursday") {
      return 'thursday'.tr;
    } else if (day == "Friday") {
      return 'friday'.tr;
    } else if (day == "Saturday") {
      return 'saturday'.tr;
    } else if (day == "Sunday") {
      return 'sunday'.tr;
    } else {
      return "Error";
    }
  }

  void launchURL(String url) async {
    //await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      String httpUrl = "http://" + url;
      if (await canLaunch(httpUrl)) {
        launch(httpUrl);
      } else {
        String httpsUrl = "https://" + url;
        if (await canLaunch(httpsUrl)) {
          launch(httpsUrl);
        } else {
          throw "$url not found";
        }
      }
    }
  }

  Widget googlemap(String url) {
    return InkWell(
      onTap: () {
        //Get.toNamed("/mapViewForShowMap");
        _storeDetailController.openGoogelMap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(image: NetworkImage(url, scale: 0.1), fit: BoxFit.cover, scale: 0.1),
        ),
      ),
    );
  }

  Widget noDataFoundContainer() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "No data found",
        style: TextStyle(
          fontFamily: AppFont.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
