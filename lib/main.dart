import 'dart:convert';
import 'dart:io';

import 'package:dakowabook/projectcolors.dart';
import 'package:dakowabook/provider/authprovider.dart';
import 'package:dakowabook/provider/literatureprovider.dart';
import 'package:dakowabook/screens/auth/loginscreen.dart';
import 'package:dakowabook/screens/common/dissmisskeyboard.dart';
import 'package:dakowabook/services/authhttpservice.dart';
import 'package:dakowabook/utils/sharedprefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: materialMainColor,
    primaryColor: mainColor,
    primaryIconTheme: IconThemeData(color: Colors.white),
    primaryColorBrightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'SofiaProRegular'

);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: materialMainColor,
    primaryColor: mainColor,
    accentColor: mainColor,
    primaryIconTheme: IconThemeData(color: Colors.white),
    primaryColorBrightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'SofiaProRegular'
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs.instance.initializePreference();
  Upgrader().clearSavedSettings(); // REMOVE this for release builds

  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin!.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }



  FirebaseMessaging.instance.subscribeToTopic('newbook').then((value) => print("subscribed to topic newbook"));
  FirebaseMessaging.instance.subscribeToTopic('promotion').then((value) => print("subscribed to topic promotion"));

  FirebaseMessaging.instance .getInitialMessage()
      .then((RemoteMessage? message) {
        print(message);

  });

  FirebaseMessaging.onMessage.listen((RemoteMessage? message)async {
    RemoteNotification notification = message!.notification!;
    AndroidNotification android = message.notification!.android!;

    print("MESSAGE IS COMING");


    if (notification != null && android != null && !kIsWeb) {
      print("WATCH FOR DATAAAAAA: ");
      //print("notification image should appear here: " + notification.android!.imageUrl!);
      String? largeIcon;// =   await _base64encodedImage('${notification.android!.imageUrl}');
      String? bigPicture;// =  await _base64encodedImage('${notification.android!.imageUrl}');
      BigPictureStyleInformation? bigPictureStyleInformation;
      AndroidNotificationDetails? andImage;

      if(notification.android!.imageUrl != null){
        largeIcon =   await _base64encodedImage('${notification.android!.imageUrl}');
        bigPicture =  await _base64encodedImage('${notification.android!.imageUrl}');
        bigPictureStyleInformation =
            BigPictureStyleInformation(
              ByteArrayAndroidBitmap.fromBase64String(bigPicture), //Base64AndroidBitmap(bigPicture),
              largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
              contentTitle: '${notification.title}',
              htmlFormatContentTitle: true,
              summaryText: '${notification.body}',
              htmlFormatSummaryText: false,
              //hideExpandedLargeIcon: true
            );

        andImage = AndroidNotificationDetails(
            channel!.id,
            channel!.name,
            channel!.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'ic_notif',
            enableLights: true,
            styleInformation: bigPictureStyleInformation
        );
      }

      AndroidNotificationDetails andWOImage = AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channel!.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'ic_notif',
          enableLights: true
      );

      flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,

          NotificationDetails(
            android: notification.android!.imageUrl != null &&  notification.android!.imageUrl!.isNotEmpty
            ? andImage : andWOImage,
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
   // print(message.notification!.android!.imageUrl);
    //Navigator.pushNamed(context, '/message',
    //    arguments: MessageArguments(message, true));
  });

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: mainColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: mainColor,
      )
  );
  runApp(
      MultiProvider(providers: [
       ChangeNotifierProvider(create: (context) => LiteratureProvider()),
       ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
        child: MyApp(),
      )
  );

}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return DismissKeyboard(
      child: UpgradeAlert(
        child: GetMaterialApp(
            title: 'Dakowa Books',
            theme: Platform.isIOS ? kIOSTheme : kDefaultTheme,
            home: LoginScreen()
        ),
      ),
    );
  }
}

Future<String> _base64encodedImage(String url) async {
  if(url != null && url.isNotEmpty){
    final http.Response response = await http.get(Uri.parse(url));
    final String base64Data = base64Encode(response.bodyBytes);
    return base64Data;
  }else{
    return "";
  }
}