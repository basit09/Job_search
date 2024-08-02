import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// upload image  to storage
  Future<String> uploadImageToStorage(String fileName, Uint8List file) async {
    Reference ref = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static firebaseOptions() {
    if (Platform.isAndroid) {
      return const FirebaseOptions(
          apiKey: 'AIzaSyC9g0iYO48dBjL5l18XmKaOrVl4eFofo6w',
          appId: '1:244716624517:android:fb321bf3e3ce79812aa7ec',
          messagingSenderId: '244716624517',
          projectId: 'job-search-e3fea',
          storageBucket: 'gs://job-search-e3fea.appspot.com');
    }
  }
}
