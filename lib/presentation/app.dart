// lib/presentation/app.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/presentation/routes/app_pages.dart';
// import 'package:terra_brain/presentation/service/notif_handler.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // final NotificationHandler _notificationHandler = NotificationHandler();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Novelku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
