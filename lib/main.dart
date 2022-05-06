import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/MyBooking/MyBooking.dart';
import 'package:reserve_for_you_user/Pages/Profile/Setting/givenReview.dart';
import 'package:reserve_for_you_user/Pages/Tabbar/BottomNavBar.dart';
import 'package:reserve_for_you_user/Pages/Tabbar/bottombar_controller.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'Helper/Localization/localization.dart';
import 'Helper/NotificatiokKeys.dart';
import 'Helper/router.dart';
import 'package:get/get.dart';
import 'Helper/url.dart';

/////////
Directory appDocsDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    Stripe.publishableKey = stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.reserved4you';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
  }
  appDocsDir = await getApplicationDocumentsDirectory();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white, statusBarBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, criticalAlert: true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  Get.put(LifeCycleController());
  await firebaseMessaging();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  PluginGooglePlacePicker.initialize(
    androidApiKey: googleAndroidApikey,
    iosApiKey: googleiOSApikey,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Color(AppColor.logoBgColor)));
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  await bottomBarController.getNotifications();
  runApp(GetMaterialApp(
    translations: AppLocalization(),
    navigatorKey: navigatorKey,
    localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, SfGlobalLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
    supportedLocales: [
      const Locale('en'),
      const Locale('de'),
    ],
    fallbackLocale: Locale('en'),
    debugShowCheckedModeBanner: false,
    getPages: RouterForApp.route,
    initialRoute: '/splashView',
  ));
}

RemoteMessage messageGlobel;
bool isNotification = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

/// firebase messaging integration
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidNotificationChannel channel;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  bottomBarController.notificationBadge.value = true;
}

Future<void> firebaseMessaging() async {
  String token = Platform.isIOS ? await FirebaseMessaging.instance.getAPNSToken() : await FirebaseMessaging.instance.getToken();
  print("token = $token");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    print("onSelectNotification Called");
    if (payload != null) {
      final newPay = jsonDecode(payload);
    }
  });

  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    List<IOSNotificationAttachment> attach = [];

    print("onMessage Called");

    bottomBarController.notificationBadge.value = true;
    if (Platform.isAndroid) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      String iconPath;
      if (message.data.containsKey('icon') && message.data['icon'] != null) {
        iconPath = await downloadImage(message.data['icon']);
      }
      Map<String, dynamic> payload = message.data;
      attach.add(IOSNotificationAttachment(iconPath));
      flutterLocalNotificationsPlugin.show(
        notification != null ? notification.hashCode : 0,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: '@mipmap/ic_launcher',
            largeIcon: FilePathAndroidBitmap(iconPath),
          ),
          iOS: IOSNotificationDetails(
            subtitle: channel.description,
            presentSound: true,
            presentAlert: true,
            //   attachments: attach,
          ),
        ),
        payload: jsonEncode(payload),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp Called ");
    print(message);
    print(message.data);
    await Firebase.initializeApp();
    if (message.notification.title == 'Stornierung!') {
      Get.to(() => MyBooking(), arguments: {
        'status': 'cancel',
        'appointment_id': message.data['appointment_id'],
      });
    } else if (message.notification.title == "Termin verschieben ?") {
      Get.to(() => MyBooking(), arguments: {
        'status': 'pending',
        'appointment_id': message.data['appointment_id'],
      });
    } else if (message.notification.title == "Dein Termin ist bald !") {
      Get.to(() => MyBooking(), arguments: {
        'status': 'completed',
        'appointment_id': message.data['appointment_id'],
      });
    } else if (message.notification.title == "Neue Antwort !") {
      Get.offAll(() => BottomNavBar());
      Get.to(() => Givenreview(), arguments: {
        'appointment_id': message.data['appointment_id'],
      });
    } else if (message.notification.title == "Bewertungsanfrage !") {
      Get.to(() => MyBooking(), arguments: {
        'status': 'completed',
        'appointment_id': message.data['appointment_id'],
        'id': message.data["id"],
        'type': message.data["type"],
      });
    } else if (message.notification.title == "Kundenprofil - Anfrage !") {
      print('Kundenprofilkjnkejhekgjhekjehgkjghjk3');
      Get.to(() => BottomNavBar(pageIndex: 2));
    } else if (message.notification.title == "Neue Buchung!") {
      Get.to(() => MyBooking(), arguments: {
        'status': 'pending',
        'appointment_id': message.data['appointment_id'],
      });
    } else {
      Get.to(() => BottomNavBar(pageIndex: 2));
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) async {
    if (message != null) {
      messageGlobel = message;
      isNotification = true;
      await Firebase.initializeApp();
      if (message.notification != null) {
      }
      if (message.notification.title == 'Stornierung!') {
        Get.to(() => MyBooking(), arguments: {
          'status': 'cancel',
          'appointment_id': message.data['appointment_id'],
        });
      } else if (message.notification.title == "Termin verschieben ?") {
        Get.to(() => MyBooking(), arguments: {
          'status': 'pending',
          'appointment_id': message.data['appointment_id'],
        });
      } else if (message.notification.title == "Dein Termin ist bald !") {
        Get.to(() => MyBooking(), arguments: {
          'status': 'pending',
          'appointment_id': message.data['appointment_id'],
        });
      } else if (message.notification.title == "Neue Antwort !") {
        Get.offAll(() => BottomNavBar());
        Get.to(() => Givenreview(), arguments: {
          'appointment_id': message.data['appointment_id'],
        });
      } else if (message.notification.title == "Bewertungsanfrage !") {
        Get.to(() => MyBooking(), arguments: {
          'status': 'completed',
          'appointment_id': message.data['appointment_id'],
        });
      } else if (message.notification.title.toString() == "Kundenprofil - Anfrage !") {
        print('Kundenprofilkjnkejhekgjhekjehgkjghjk2');
        Get.to(() => BottomNavBar(pageIndex: 2));
      } else if (message.notification.title == "Neue Buchung!") {
        Get.to(() => MyBooking(), arguments: {
          'status': 'pending',
          'appointment_id': message.data['appointment_id'],
        });
      } else {
        Get.to(() => BottomNavBar(pageIndex: 2));
      }
    }
  });
}

Future<dynamic> onSelectNotification(data) async {
  Map<String, dynamic> payload = jsonDecode(data);

  if (payload['title'] == 'Stornierung!') {
    Get.to(() => MyBooking(), arguments: {
      'status': 'cancel',
      'appointment_id': payload['appointment_id'],
    });
  } else if (payload['title'] == "Termin verschieben ?") {
    Get.to(() => MyBooking(), arguments: {
      'status': 'pending',
      'appointment_id': payload['appointment_id'],
    });
  } else if (payload['title'] == "Dein Termin ist bald !") {
    Get.to(() => MyBooking(), arguments: {
      'status': 'pending',
      'appointment_id': payload['appointment_id'],
    });
  } else if (payload['title'] == "Neue Antwort !") {
    Get.offAll(() => BottomNavBar());
    Get.to(() => Givenreview(), arguments: {
      'appointment_id': payload['appointment_id'],
    });
  } else if (payload['title'] == "Bewertungsanfrage !") {
    Get.to(() => MyBooking(), arguments: {
      'status': 'completed',
      'appointment_id': payload['appointment_id'],
      'id': payload['id'],
      'type': payload['type'],
    });
  } else if (payload['title'].toString() == "Kundenprofil - Anfrage !") {
    print('Kundenprofilkjnkejhekgjhekjehgkjghjk1');
    Get.to(() => BottomNavBar(pageIndex: 2));
  } else if (payload['title'] == "Neue Buchung!") {
    Get.to(() => MyBooking(), arguments: {
      'status': 'pending',
      'appointment_id': payload['appointment_id'],
    });
  } else {
    Get.to(() => BottomNavBar(pageIndex: 2));
  }
}

Future onDidReceiveLocalNotification(
  int id,
  String title,
  String body,
  String payload,
) async {
  print("iOS notification $title $body $payload");
}

Future<String> downloadImage(String image) async {
  try {
    var imageId = await ImageDownloader.downloadImage(image);
    if (imageId == null) {
      return null;
    }
    var path = await ImageDownloader.findPath(imageId);
    return path;
  } on PlatformException catch (error) {
    print(error);
  }
  return null;
}
