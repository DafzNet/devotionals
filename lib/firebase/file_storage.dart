import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadFileToFirebaseStorage(File file, String storagePath) async {
  try {
    // Create a reference to the location you want to upload to in Firebase Storage
    Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);

    UploadTask uploadTask = storageReference.putFile(file);

    // Get the download URL of the uploaded file
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Return the download URL
    return downloadURL;
  } catch (e) {
    print('Error uploading file: $e');
    return null;
  }
}
