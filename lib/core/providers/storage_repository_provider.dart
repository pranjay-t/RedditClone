import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/core/constants/failure.dart';
import 'package:reddit_clone/core/constants/type_def.dart';
import 'package:reddit_clone/cloudinary_storage.dart';

final cloudinaryStorageProvider = Provider((ref) {
  return StorageRepository();
});

class StorageRepository {
  FutureEither<List<String>> storeFiles({
  required String path,
  required String id,
  required List<XFile> files,
  required Uint8List? webFile,
  required bool isVideo, 
}) async {
  try {
    final List<String> uploadedUrls = [];
    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${Secret().cloudNameCloudinary}/upload');

    if (kIsWeb && webFile != null) {
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = Secret().uploadPresetCloudinary
        ..fields['api_key'] = Secret().apiKeyCloudinary
        ..fields['public_id'] = '$path/$id'
        ..fields['resource_type'] = isVideo ? 'video' : 'image'
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          webFile,
          filename: isVideo ? '$id.mp4' : '$id.jpg',
        ));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      uploadedUrls.add(data['secure_url']);
    } else if (!kIsWeb && files.isNotEmpty) {
      for (var file in files) {
        final request = http.MultipartRequest('POST', uri)
          ..fields['upload_preset'] = Secret().uploadPresetCloudinary
          ..fields['api_key'] = Secret().apiKeyCloudinary
          ..fields['public_id'] = '$path/${id}_${file.name}'
          ..fields['resource_type'] = isVideo ? 'video' : 'image'
          ..files.add(await http.MultipartFile.fromPath('file', file.path));

        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        uploadedUrls.add(data['secure_url']);
      }
    } else {
      throw Exception('No valid file provided for upload.');
    }

    return right(uploadedUrls);
  } catch (e) {
    return left(Failure(e.toString()));
  }
}

}
