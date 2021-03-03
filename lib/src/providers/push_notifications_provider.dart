import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print('====== FCM Token ======');
      print(token);
    });

    //fIaynhfKT7O78DWeImukOz:APA91bFEoEMaIq44iE81qzivqw5mDC1FSleKYUphjBlUaA_l6gN0uv68Xb36vLCQa_Cpeu7HtYbnNQAHM4RYiYbqVFkSnRX0gDpZtAdRlBvpkxQYDqAkS-Efen4nPmuCPK9W869gRvlP

    //Redmi Note 7 FCM token
    //c8ZKZ0pKTDCVR_Tb9PpSRX:APA91bGOnacG56fBUX6tFXZMNe3-Mci6nuWCrtIdUTM6aTRa4pq93-rAKdVSyOZ3SQCoO4tsp5zwFLmQ9_T0yLEdwsTnrgi2wLlEv1ZimfMW5d31bbxhpzPwBQRyxVDdK5JghEniB0Bx

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> info) async {
        print('====== On Message ======');
        print(info);
      },
      onLaunch: (Map<String, dynamic> info) async {
        print('====== On Launch ======');
        print(info);
      },
      onResume: (Map<String, dynamic> info) async {
        print('====== On Resume ======');
        print(info);
      },
    );
  }
}
