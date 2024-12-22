import 'dart:typed_data';

abstract class StorageRepo {
  // upload profile images on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String fileName); 

  // for web
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName); 
}