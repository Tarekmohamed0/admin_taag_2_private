import 'dart:io';
import 'dart:typed_data';
import 'package:admin_taag/core/services/stoarage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as b;

class FireStorage implements StoarageService {
  final stoargeReference = FirebaseStorage.instance.ref();

  @override
  Future<String> uploadFile(File file, String path) async {
    String fileName = b.basename(file.path);
    var fileReference = stoargeReference.child('$path/$fileName');
    await fileReference.putFile(file); // Upload file
    return await fileReference.getDownloadURL(); // Get the file URL
  }

  @override
  Future<String> uploadBytes(Uint8List bytes, String path) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var fileReference = stoargeReference.child('$path/$fileName');
    await fileReference.putData(bytes); // Upload bytes
    return await fileReference.getDownloadURL(); // Get the file URL
  }
}
