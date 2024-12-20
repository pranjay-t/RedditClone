import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/failure.dart';
import 'package:reddit_clone/core/constants/type_def.dart';
import 'package:reddit_clone/cloudinary_storage.dart';

final cloudinaryStorageProvider = Provider((ref) {
  return StorageRepository();
});

class StorageRepository {
  
  FutureEither<String> storeFile({ 
    required String path,
    required String id,
    required File? file,
    required Uint8List? webFile,
  }) async {
    try {

      final uri = Uri.parse('https://api.cloudinary.com/v1_1/${Secret().cloudNameCloudinary}/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = Secret().uploadPresetCloudinary
        ..fields['api_key'] = Secret().apiKeyCloudinary
        ..fields['public_id'] = '$path/$id';

      if (kIsWeb && webFile != null) {

        final multipartFile = http.MultipartFile.fromBytes(
          'file',
          webFile,
          filename: '$id.jpg',
        );
        request.files.add(multipartFile);

    } else if (!kIsWeb && file != null) {

        final multipartFile = await http.MultipartFile.fromPath('file', file.path);
        request.files.add(multipartFile);

    } else {

      throw Exception('No valid file provided for upload.');
      
    }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      
      final data = json.decode(respStr);

      String secureUrl = data['secure_url'];

      return right(secureUrl);
    } catch (e) {
      return left(Failure(e.toString()));

    } 
  }
}
