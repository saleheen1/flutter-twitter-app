import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_twitter_app/core/constants/appwrite_constants.dart';
import 'package:flutter_twitter_app/core/providers/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageRepository(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageRepository {
  final Storage _storage;
  StorageRepository({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }
}
