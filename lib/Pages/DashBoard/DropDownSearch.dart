import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reserve_for_you_user/Helper/NotificatiokKeys.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardController.dart';

// ignore: must_be_immutable
class DropDownSearch extends StatelessWidget {
  DashBoardController _iconController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Container(
          margin: EdgeInsets.only(
            top: 215,
          ),
          height: 50,
          width: Get.width * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFdb8a8a),
          ),
          child: InkWell(
            onTap: () {
              _iconController.fabIconNumber.value = !_iconController.fabIconNumber.value;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Image.asset(
                  AssestPath.homeView + "Search.png",
                  height: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'advanceSearch'.tr,
                  style: TextStyle(
                      color: Color(
                        AppColor.logoBgColor,
                      ),
                      fontFamily: AppFont.regular,
                      fontSize: 20),
                ),
                Spacer(),
                Obx(
                  () => iconButton(),
                )
              ],
            ),
          ),
        )),
        Obx(
          () => Visibility(visible: _iconController.fabIconNumber.value, child: dropDownContainer(context)),
        ),
      ],
    );
  }

// IconButton
  Container iconButton() {
    return Container(
      child: IconButton(
          icon: _iconController.fabIconNumber.value == false
              ? Icon(Icons.keyboard_arrow_up, color: Color(AppColor.logoBgColor), size: 35)
              : Icon(Icons.keyboard_arrow_down, color: Color(AppColor.logoBgColor), size: 35),
          onPressed: () {
            _iconController.fabIconNumber.value = !_iconController.fabIconNumber.value;
          }),
    );
  }

// DropDown Menu
  Center dropDownContainer(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 265),
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
            width: Get.width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(blurRadius: 200, color: Colors.grey[300], offset: Offset(0, 20)),
              ],
              color: Color(0xFFffffff),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => popUpmenu(
                    context,
                    buildTextFieldContainer(img: "Sub-categories.png", hinttext: _iconController.selectedSubCategoryName.value, enabled: false),
                  ),
                ),
                Obx(
                  () => dropdownfieldForSuggestion(
                    img: "Findsalonorparlor.png",
                    enabled: true,
                  ),
                ),
                Obx(
                  () => InkWell(
                    onTap: () {
                      _iconController.openPlacePicker(context);
                    },
                    child: buildTextFieldContainer(img: "pin.png", hinttext: _iconController.selectedAddress.value, enabled: false),
                  ),
                ),
                Obx(
                  () => celenderButton(context),
                ),
                searchButton(),
                clearButton(),
              ],
            ),
          ),
          Obx(() => suggestionContainer()),
        ],
      ),
    );
  }

  Widget suggestionContainer() {
    return Visibility(
      visible: _iconController.isSuggestionPopUpOpen.value,
      child: Container(
          margin: EdgeInsets.only(top: 380, left: 20),
          padding: EdgeInsets.only(
            left: 35,
          ),
          width: Get.width * 0.80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey[200])]),
          child: Column(
            children: [
              Obx(
                () => Container(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  height: 45,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _iconController.onSuggetionStoreTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _iconController.currentSuggetionTab.value == "Store" ? Color(0xFFdb8a8a) : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Store",
                                style: TextStyle(
                                  color: _iconController.currentSuggetionTab.value == "Store" ? Colors.white : Colors.grey,
                                  fontFamily: AppFont.regular,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: _iconController.onSuggetionServiceTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _iconController.currentSuggetionTab.value == "Services" ? Color(0xFFdb8a8a) : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Services",
                                style: TextStyle(
                                  color: _iconController.currentSuggetionTab.value == "Services" ? Colors.white : Colors.grey,
                                  fontFamily: AppFont.regular,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suggestionList(),
            ],
          )),
    );
  }

  Widget suggestionList() {
    var list = [];
    if (_iconController.currentSuggetionTab.value == "Store") {
      _iconController.arrStoreSuggestionString.forEach((element) {
        if (element.url == "store") {
          list.add(element);
        }
      });
    } else {
      _iconController.arrStoreSuggestionString.forEach((element) {
        if (element.url != "store") {
          list.add(element);
        }
      });
    }
    return ListView.builder(
      // padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, index) {
        // ignore: invalid_use_of_protected_member
        var currentObj = list[index];

        return InkWell(
          onTap: () {
            _iconController.suggestionStr.value.text = currentObj.name;
            _iconController.isSuggestionPopUpOpen.value = false;
            _iconController.selectedSuggestionObj.value = currentObj;
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              currentObj.name,
              style: TextStyle(
                fontFamily: AppFont.regular,
                fontSize: 15,
              ),
            ),
          ),
        );
      },
    );
  }

  InkWell searchButton() {
    return InkWell(
      onTap: () {
        _iconController.fabIconNumber.value = !_iconController.fabIconNumber.value;
        _iconController.getAllDataForDashboard();
        _iconController.suggestionStr.value.text = null;
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'searchNow'.tr,
                    style: TextStyle(
                        fontFamily: AppFont.regular,
                        color: Color(
                          AppColor.logoBgColor,
                        ),
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            Align(
                alignment: FractionalOffset.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Color(AppColor.logoBgColor),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Container buildTextFieldContainer({String hinttext, String searchimg, bool enabled = false, String img, TextEditingController controller}) {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        padding: EdgeInsets.only(bottom: 10, top: 10),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFFf9f9fb),
        ),
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            child: TextField(
              textInputAction: TextInputAction.next,
              textAlignVertical: TextAlignVertical.center,
              enabled: enabled,
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hinttext,
                  hintStyle: TextStyle(
                    fontFamily: AppFont.regular,
                    fontSize: 14,
                    color: (hinttext == 'subCategorys'.tr || hinttext == 'postCodeOrArea'.tr) ? Color(0xFFafb3b8) : Colors.black,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  icon: Image.asset(
                    AssestPath.homeView + "$img",
                    height: 13,
                    fit: BoxFit.cover,
                    color: Color(0xFFafb3b8),
                  )),
            )));
  }

  InkWell celenderButton(BuildContext context) {
    return InkWell(
        onTap: () {
          selectDate(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFf9f9fb),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  Icons.date_range_sharp,
                  color: Color(0xFFADB6C2),
                  size: 16,
                ),
              ),
              Text(
                _iconController.isDateSelected.value ? _iconController.formatedDate.value : _iconController.selectedDate.value,
                style: TextStyle(
                    color: _iconController.isDateSelected.value ? Color(AppColor.textFieldtextColor) : Color(AppColor.textFieldtextColor),
                    fontSize: 14,
                    fontFamily: AppFont.regular),
              )
            ],
          ),
        ));
  }

  Widget popUpmenu(BuildContext context, Widget widget) {
    return PopupMenuButton<String>(
      child: widget,
      onSelected: (String str) {
        _iconController.selectedSubCategoryName.value = str;
        _iconController.findSubCategoryIdFromName();
      },
      itemBuilder: (BuildContext context) {
        return _iconController.arrCategoryWiseSubCategoryString.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Container(
              height: 25,
              width: 200,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  choice,
                  style: TextStyle(
                    fontFamily: AppFont.medium,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList();
      },
    );
  }

  Widget dropdownfieldForSuggestion({String hinttext, String searchimg, String img, bool enabled = true}) {
    return Container(
      //padding: EdgeInsets.only(top: 8, bottom: 8),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFf9f9fb),
      ),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 20,
          right: 10,
        ),
        child: TextField(
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.center,
          enabled: enabled,
          focusNode: _iconController.myFocusNode,
          controller: _iconController.suggestionStr.value,
          keyboardType: TextInputType.text,
          autocorrect: false,
          style: TextStyle(fontFamily: AppFont.regular, color: Colors.black, fontSize: 15),
          onChanged: (str) {
            if (str.isEmpty || _iconController.suggestionStr.value.text == '') {
              _iconController.isSuggestionPopUpOpen.value = false;

              _iconController.arrStoreSuggestionString.clear();
            } else if (str.length > 2) {
              _iconController.getSuggestions(searchtext: str);
            }
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'findsalonOrParlor'.tr,
              hintStyle: TextStyle(fontFamily: AppFont.regular, color: Color(0xFFafb3b8), fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              icon: Image.asset(
                AssestPath.homeView + "$img",
                height: 13,
                fit: BoxFit.cover,
                color: Color(0xFFafb3b8),
              )),
        ),
      ),
    );
  }

  InkWell clearButton() {
    return InkWell(
      onTap: () {
        _iconController.suggestionStr.value.text = "";
        _iconController.selectedAddress.value = 'postCodeOrArea'.tr;

        _iconController.isDateSelected.value = false;

        _iconController.formatedDate.value = '';
        _iconController.resetAdvanceSerach();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'clear'.tr,
                style: TextStyle(
                  fontFamily: AppFont.medium,
                  color: Color(0xFFdb8a8a),
                  fontSize: 17,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData().copyWith(
                colorScheme: ColorScheme.light(
              primary: Color(0xffdb8a8a),
            )),
            child: child,
          );
        },
        initialDate: _iconController.currentDate.value,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      _iconController.currentDate.value = pickedDate;
      _iconController.formatedDate.value = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}".tr;
      _iconController.isDateSelected.value = true;
    } else {
      _iconController.isDateSelected.value = false;
    }
  }
}
