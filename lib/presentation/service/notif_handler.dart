import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    // Minta izin notifikasi
    _firebaseMessaging.requestPermission();

    // Handler saat aplikasi Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Pesan diterima di Foreground: ${message.notification?.title}');
      // Tampilkan notifikasi atau update UI
    });

    // Handler saat aplikasi di Background dan dibuka melalui notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notifikasi dibuka di Background: ${message.notification?.title}');
      // Navigasi atau update UI
    });

    // Handler saat aplikasi Terminated
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Notifikasi diterima saat aplikasi Terminated: ${message.notification?.title}');
        // Navigasi atau update UI
      }
    });
  }
}
