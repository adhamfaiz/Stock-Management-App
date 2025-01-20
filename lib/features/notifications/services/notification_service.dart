// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._();
//   factory NotificationService() => _instance;
//   NotificationService._();

//   final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final iosSettings = const DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
    
//     final initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notifications.initialize(initSettings);
//   }

//   Future<void> showLowStockNotification({
//     required int id,
//     required String productName,
//     required int currentStock,
//     required int threshold,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'low_stock_channel',
//       'Low Stock Alerts',
//       channelDescription: 'Notifications for low stock items',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     final iosDetails = const DarwinNotificationDetails();

//     final details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       id,
//       'Low Stock Alert',
//       '$productName is running low (Current: $currentStock, Threshold: $threshold)',
//       details,
//     );
//   }

//   Future<void> showStockOutNotification({
//     required int id,
//     required String productName,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'stock_out_channel',
//       'Stock Out Alerts',
//       channelDescription: 'Notifications for out of stock items',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     final iosDetails = const DarwinNotificationDetails();

//     final details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       id,
//       'Stock Out Alert',
//       '$productName is out of stock!',
//       details,
//     );
//   }

//   // Cancel all notifications and dispose of the service
//   Future<void> dispose() async {
//     await cancelAll();
//   }

//   // Cancel all active notifications
//   Future<void> cancelAll() async {
//     await _notifications.cancelAll();
//   }
// }
