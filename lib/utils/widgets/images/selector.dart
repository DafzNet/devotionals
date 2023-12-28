
// ignore_for_file: prefer_const_declarations, unused_local_variable

import 'dart:io';

import 'package:devotionals/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerCropper{
  final ImagePicker _picker = ImagePicker();
  File? _photo;

  // Future<File?> _cropImage(File? photo) async {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: photo!.path,
  //       compressFormat: ImageCompressFormat.jpg,
  //       compressQuality: 100,
  //       uiSettings: [
  //         AndroidUiSettings(
  //             toolbarTitle: 'CRIC',
  //             toolbarColor: cricColor.shade200,
  //             toolbarWidgetColor: Colors.white,
  //             initAspectRatio: CropAspectRatioPreset.square,
  //             lockAspectRatio: true),
  //         IOSUiSettings(
  //           title: 'CRIC',
  //         ),
  //       ],
  //     );
      
  //     return File(croppedFile!.path);
  // }

  Future<File?> imgFromGallery({int quality=100, bool crop=true}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: quality,
      );

      if (pickedFile != null) {
        // if (crop==true){
        //  _photo = await _cropImage(File(pickedFile.path));
        //  return _photo;
        // }
        _photo = File(pickedFile.path);
        return _photo;
      }
      return null;
    }


  Future<File?> imgFromCamera({int quality=100, bool crop = true}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: quality,
    );

        if (pickedFile != null) {
          // if (crop){
          //   _photo = await _cropImage(File(pickedFile.path));
          //   return _photo;
          // }
        _photo = File(pickedFile.path);
        return _photo;
      }
  }
}
