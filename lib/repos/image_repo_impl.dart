import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:admin_taag/core/errors/failures.dart';
import 'package:admin_taag/core/services/firebase_firestore_service.dart';
import 'package:admin_taag/core/services/stoarage_service.dart';
import 'package:admin_taag/core/utils/backend_endpoint.dart';
import 'package:admin_taag/repos/image_upload.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class ImagesRepoImpl implements ImagesRepo {
  final StoarageService stoarageService;
  ImagesRepoImpl(this.stoarageService);

  @override
  Future<Either<Failure, String>> uploadImage(dynamic image) async {
    try {
      String url;

      if (kIsWeb) {
        // If on the web, `image` is expected to be Uint8List
        url = await stoarageService.uploadBytes(
          image as Uint8List,
          BackendEndpoint.kAnnunc,
        );
      } else {
        // On native, `image` is a File
        url = await stoarageService.uploadFile(
          image as File,
          BackendEndpoint.kAnnunc,
        );
      }
      await FireStoreService().updateUserData(
        path: BackendEndpoint.kAnnunc,
        data: {
          'Annunc_image': url,
        },
      );
      log('Image uploaded successfully: $url');
      return Right(url);
    } catch (e) {
      log('Error uploading image: $e');
      return Left(ServerFailure('Failed to upload image'));
    }
  }
}
