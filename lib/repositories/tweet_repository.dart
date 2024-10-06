import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/constants/appwrite_constants.dart';
import 'package:flutter_twitter_app/core/errors/failure.dart';
import 'package:flutter_twitter_app/core/providers/providers.dart';
import 'package:flutter_twitter_app/core/type_defs.dart';
import 'package:flutter_twitter_app/models/tweet_model.dart';

final tweetRepositoryProvider = Provider((ref) {
  return TweetRepositoryImpl(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class TweetRepository {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
  Future<List<Document>> getTweetsByHashtag(String hashtag);
}

class TweetRepositoryImpl implements TweetRepository {
  final Databases _db;
  final Realtime _realtime;
  TweetRepositoryImpl({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.dbId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
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
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.dbId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.dbId}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.dbId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );
      return right(document);
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
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.dbId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );
      return right(document);
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
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.dbId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return document.documents;
  }

  @override
  Future<Document> getTweetById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.dbId,
      collectionId: AppwriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.dbId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.dbId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.search('hashtags', hashtag),
      ],
    );
    return documents.documents;
  }
}
