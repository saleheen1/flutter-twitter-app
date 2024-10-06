import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/enums/notification_type_enum.dart';
import 'package:flutter_twitter_app/repositories/notification_repository.dart';
import 'package:flutter_twitter_app/models/notification_model.dart'
    as notiModel;

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    notificationRepoImpl: ref.watch(notificationRepoProvider),
  );
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationRepoProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationRepoImpl _notificationRepoImpl;
  NotificationController({required NotificationRepoImpl notificationRepoImpl})
      : _notificationRepoImpl = notificationRepoImpl,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = notiModel.Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    final res = await _notificationRepoImpl.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<notiModel.Notification>> getNotifications(String uid) async {
    final notifications = await _notificationRepoImpl.getNotifications(uid);
    return notifications
        .map((e) => notiModel.Notification.fromMap(e.data))
        .toList();
  }
}
