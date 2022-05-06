import 'package:get/get.dart';
import 'package:reserve_for_you_user/Pages/Authentication/ForgotPassword/ForgotPasswordView.dart';
import 'package:reserve_for_you_user/Pages/Authentication/GuestUser/GuestUserView.dart';
import 'package:reserve_for_you_user/Pages/Authentication/Introduction/IntroductionView.dart';
import 'package:reserve_for_you_user/Pages/Authentication/Login/LoginView.dart';
import 'package:reserve_for_you_user/Pages/Authentication/SignUp/SignUpView.dart';
import 'package:reserve_for_you_user/Pages/BookingSummary/ConfirmPaymentView.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DashBoardView.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/About/ExpertReviews/StylistExpertReview.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/About/MapViewForShowMap.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/GiveFeedBack/GiveFeedback.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/GiveFeedBack/SelectEmployee.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/Reviews/GiveFeedBack/selectedServices.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/ServiceView/ShowDetailsView.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/DetailPage/StoreDetailsView.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/Filters/FilterView.dart';
import 'package:reserve_for_you_user/Pages/DashBoard/Filters/Mapview.dart';
import 'package:reserve_for_you_user/Pages/MainCategory/SelectMainCategoryView.dart';
import 'package:reserve_for_you_user/Pages/PayPalView/PaypalView.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/PoceedToPayView.dart';
import 'package:reserve_for_you_user/Pages/ProceedToPay/SelectDateAndTime/TimeSlotForService.dart';
import 'package:reserve_for_you_user/Pages/Profile/Edit_Page.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/About_View.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/Change_Password.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/CalenderAppointmentDetail.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/MyBooking.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/PrivatePolicy.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/cencelPolicy.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/givenReview.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/setting_page.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/term&condition.dart';
import 'package:reserve_for_you_user/Pages/Tabbar/BottomNavBar.dart';
import 'package:reserve_for_you_user/Pages/checkout_Process/CheckOutView.dart';
import 'package:reserve_for_you_user/Pages/splashView.dart';

class RouterForApp {
  static final route = [
    GetPage(
      name: '/dashboard',
      page: () => DashBoardView(),
    ),
    GetPage(
      name: '/filter',
      page: () => FilterView(),
    ),
    GetPage(
      name: '/splashView',
      page: () => SplashView(),
    ),
    GetPage(
      name: '/introduction',
      page: () => IntroductionView(),
    ),
    GetPage(
      name: '/login',
      transition: Transition.downToUp,
      page: () => LoginView(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignUpView(),
    ),
    GetPage(
      name: '/forgotPassword',
      page: () => ForgotPasswordView(),
    ),
    GetPage(
      name: '/selectMainCategory',
      page: () => SelectMainCategoryView(),
    ),
    GetPage(
      name: '/mapView',
      page: () => MapView(),
    ),
    GetPage(
      name: '/storeDetailsView',
      page: () => StoreDetailsView(),
    ),
    GetPage(
      name: '/proceedToPayView',
      page: () => ProceedToPayView(),
    ),
    GetPage(
      name: '/timeSlotForService',
      page: () => TimeSlotForService(),
    ),
    GetPage(
      name: '/guestUserView',
      page: () => GuestUserView(),
    ),
    GetPage(
      name: '/checkoutProcess',
      page: () => CheckoutProcess(),
    ),
    GetPage(
      name: '/confirmPaymentView',
      page: () => ConfirmPaymentView(),
    ),
    GetPage(
      name: '/paypalView',
      page: () => PaypalView(),
    ),
    GetPage(
      name: '/showDetailsView',
      page: () => ShowDetailsView(),
    ),
    GetPage(
      name: '/bottomNavBar',
      page: () => BottomNavBar(),
    ),
    GetPage(
      name: '/stylistExpertReview',
      page: () => StylistExpertReview(),
    ),
    GetPage(
      name: '/mapViewForShowMap',
      page: () => MapViewForShowMap(),
    ),
    GetPage(
      name: '/editView',
      page: () => EditView(),
    ),
    GetPage(
      name: '/selectEmployee',
      page: () => SelectEmployee(),
    ),
    GetPage(
      name: '/bookingView',
      page: () => MyBooking(),
    ),
    GetPage(
      name: '/selectedServices',
      page: () => SelectedServices(),
    ),
    GetPage(
      name: '/stylistExpertReview',
      page: () => StylistExpertReview(),
    ),
    GetPage(
      name: '/giveFeedback',
      page: () => GiveFeedback(),
    ),
    GetPage(
      name: '/selectEmployee',
      page: () => SelectEmployee(),
    ),
    GetPage(
      name: '/selectedServices',
      page: () => SelectedServices(),
    ),
    GetPage(
      name: '/settingView',
      page: () => SettingView(),
    ),
    GetPage(
      name: '/changePassword',
      page: () => ChangePassword(),
    ),
    GetPage(
      name: '/givenreview',
      page: () => Givenreview(),
    ),
    GetPage(
      name: '/aboutView',
      page: () => AboutView(),
    ),
    GetPage(
      name: '/termConditon',
      page: () => TermConditon(),
    ),
    GetPage(
      name: '/cancelPolicy',
      page: () => CancelPolicy(),
    ),
    GetPage(
      name: '/privatePolicyView',
      page: () => PrivatePolicyView(),
    ),
    GetPage(
      name: '/calenderAppointmentDetail',
      page: () => CalenderAppointmentDetail(),
    ),
  ];
}
