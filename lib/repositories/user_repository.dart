import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/constants/appwrite_constants.dart';
import 'package:flutter_twitter_app/core/errors/failure.dart';
import 'package:flutter_twitter_app/core/providers/providers.dart';
import 'package:flutter_twitter_app/core/type_defs.dart';
import 'package:flutter_twitter_app/models/user_model.dart';

final userRepoProvider = Provider((ref) {
  return UserRepositoryImpl(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class UserRepository {
  FutureEitherVoid saveUserData(UserModel userModel);
}

class UserRepositoryImpl implements UserRepository {
  final Databases _db;
  final Realtime _realtime;
  UserRepositoryImpl({
    required Databases db,
    required Realtime realtime,
  })  : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.dbId,
        collectionId: AppwriteConstants.userCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
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
}
