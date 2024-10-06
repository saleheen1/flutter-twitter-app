import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/constants/appwrite_constants.dart';
import 'package:flutter_twitter_app/core/errors/failure.dart';
import 'package:flutter_twitter_app/core/providers/providers.dart';
import 'package:flutter_twitter_app/core/type_defs.dart';
import 'package:flutter_twitter_app/models/notification_model.dart';

final notificationRepoProvider = Provider((ref) {
  return NotificationRepoImpl(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class NotificationRepository {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationRepoImpl implements NotificationRepository {
  final Databases _db;
  final Realtime _realtime;
  NotificationRepoImpl({required Databases db, required Realtime realtime})
      : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.dbId,
        collectionId: AppwriteConstants.notificationsCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.dbId,
      collectionId: AppwriteConstants.notificationsCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.dbId}.collections.${AppwriteConstants.notificationsCollection}.documents'
    ]).stream;
  }
}
