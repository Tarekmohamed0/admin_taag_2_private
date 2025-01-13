import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AnnuncementView extends StatefulWidget {
  const AnnuncementView({super.key});

  @override
  State<AnnuncementView> createState() => _AnnuncementViewState();
}

class _AnnuncementViewState extends State<AnnuncementView> {
  String _uploadedImageUrl = '';
  bool isLoading = false;
  bool isImageSelected = false;
  final ImagePicker _picker = ImagePicker();

  // // Function to pick image on Web
  // Future<void> _pickImageWeb() async {
  //   final html.FileUploadInputElement uploadInput =
  //       html.FileUploadInputElement();
  //   uploadInput.accept = 'image/*';
  //   uploadInput.click();

  //   uploadInput.onChange.listen((event) async {
  //     final html.File? file = uploadInput.files?.first;
  //     if (file != null) {
  //       final reader = html.FileReader();
  //       reader.readAsArrayBuffer(file);
  //       reader.onLoadEnd.listen((event) async {
  //         final Uint8List fileBytes = reader.result as Uint8List;
  //         final String fileName =
  //             '${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.name)}';

  //         setState(() => isLoading = true);

  //         try {
  //           final String downloadUrl =
  //               await _uploadBytesToStorage(fileBytes, fileName);
  //           await _saveImageUrlToFirestore(downloadUrl);
  //           setState(() {
  //             _uploadedImageUrl = downloadUrl;
  //             isLoading = false;
  //             isImageSelected = true;
  //           });
  //           log('Image uploaded successfully: $downloadUrl');
  //         } catch (e) {
  //           log('Error uploading image: $e');
  //           setState(() => isLoading = false);
  //         }
  //       });
  //     }
  //   });
  // }

  // // Function to pick image on Mobile/Desktop
  // Future<void> _pickImageNative(ImageSource source) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   if (image != null) {
  //     setState(() {
  //       isImageSelected = true;
  //       isLoading = true;
  //     });

  //     final File file = File(image.path);
  //     final String fileName =
  //         '${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.path)}';

  //     try {
  //       final String downloadUrl = await _uploadFileToStorage(file, fileName);
  //       await _saveImageUrlToFirestore(downloadUrl);
  //       setState(() {
  //         _uploadedImageUrl = downloadUrl;
  //         isLoading = false;
  //       });
  //       log('Image uploaded successfully: $downloadUrl');
  //     } catch (e) {
  //       log('Error uploading image: $e');
  //       setState(() => isLoading = false);
  //     }
  //   } else {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   const SnackBar(content: Text('No image selected')),
  //     // );
  //   }
  // }

  // Function to get file extension
  String _getFileExtension(String filePath) {
    return '.${extension(filePath).replaceFirst('.', '').toLowerCase()}';
  }

  // Function to upload file to Firebase Storage (Native)
  Future<String> _uploadFileToStorage(File file, String fileName) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('Announcement/$fileName');
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Function to upload bytes to Firebase Storage (Web)
  Future<String> _uploadBytesToStorage(Uint8List bytes, String fileName) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('Announcement/$fileName');
    final UploadTask uploadTask = storageRef.putData(bytes);
    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Save image URL to Firestore
  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    final CollectionReference announcementCollection =
        FirebaseFirestore.instance.collection('Announcement');
    await announcementCollection.add({
      'Annunc_image': imageUrl,
      'uploaded_at': FieldValue.serverTimestamp(),
    });
  }

  // Show image picker options (Web or Native)
  void _showImagePickerOptions(BuildContext context) {
    if (kIsWeb) {
      _pickImageWeb();
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Pick from gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageNative(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take a photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageNative(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Uint8List? _webImageBytes;
  File? _nativeImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('إضافه اعلان'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _showImagePickerOptions(context),
              child: Container(
                width: MediaQuery.of(context).size.width - 80,
                height: 300, // لضبط ارتفاع الصورة
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _webImageBytes != null
                        ? Image.memory(
                            _webImageBytes!,
                            height: 200,
                            width: 200,
                          )
                        : _nativeImageFile != null
                            ? Image.file(
                                _nativeImageFile!,
                                height: 200,
                                width: 200,
                              )
                            : _uploadedImageUrl.isNotEmpty
                                ? Image.network(
                                    _uploadedImageUrl,
                                    height: 200,
                                    width: 200,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: FaIcon(
                                            FontAwesomeIcons.circleCheck,
                                            size: 180,
                                            color: Colors.red),
                                      );
                                    },
                                  )
                                : const Icon(Icons.image_outlined, size: 180),
              ),
            ),
          ],
        ),
      ),
    );
  }

// تعديل على _pickImageWeb
  Future<void> _pickImageWeb() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final html.File? file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) async {
          final Uint8List fileBytes = reader.result as Uint8List;
          setState(() {
            _webImageBytes = fileBytes;
          });

          final String fileName =
              '${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.name)}';

          setState(() => isLoading = true);

          try {
            final String downloadUrl =
                await _uploadBytesToStorage(fileBytes, fileName);
            await _saveImageUrlToFirestore(downloadUrl);
            setState(() {
              _uploadedImageUrl = downloadUrl;
              isLoading = false;
            });
            log('Image uploaded successfully: $downloadUrl');
          } catch (e) {
            log('Error uploading image: $e');
            setState(() => isLoading = false);
          }
        });
      }
    });
  }

// تعديل على _pickImageNative
  Future<void> _pickImageNative(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _nativeImageFile = File(image.path);
      });

      final File file = File(image.path);
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.path)}';

      setState(() => isLoading = true);

      try {
        final String downloadUrl = await _uploadFileToStorage(file, fileName);
        await _saveImageUrlToFirestore(downloadUrl);
        setState(() {
          _uploadedImageUrl = downloadUrl;
          isLoading = false;
        });
        log('Image uploaded successfully: $downloadUrl');
      } catch (e) {
        log('Error uploading image: $e');
        setState(() => isLoading = false);
      }
    }
  }
}
