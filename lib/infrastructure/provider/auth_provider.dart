import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_search/infrastructure/services/firebase_helper.dart';
import 'package:job_search/infrastructure/services/image_picker_helper.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Uint8List? _selectedImage;

  Uint8List? get selectedImage => _selectedImage;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  int _selectedRole = 0;

  int get selectedRole => _selectedRole;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void changeRoleSelection(int value) {
    /// Employer = 0, JobSeeker = 1,
    _selectedRole = value;
    notifyListeners();
  }

  /// user logged in or not
  isUserLoggedIn() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    });
  }

  getName() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    nameController.text = userDoc['name'].toString();
    emailController.text = userDoc['email'].toString();
    String imageUrl = userDoc['image'].toString();
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    final bytes = await ref.getData();
    _selectedImage = bytes;
    notifyListeners();
  }

  Future<String> updateData(String? name, String? email, Uint8List file) async {
    String response = 'Some error occurred';
    try {
      String imageUrl =
          await FirebaseHelper().uploadImageToStorage('profileImage', file);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid ?? '')
          .update({'image': imageUrl});

      if (name != null) {
        await _firestore
            .collection("users")
            .doc(_auth.currentUser?.uid)
            .update({'name': nameController.text});
        nameController.text = name;
        response = 'success';
      }
      if (email != null) {
        await _firestore
            .collection("users")
            .doc(_auth.currentUser?.uid)
            .update({'name': nameController.text});
        emailController.text = email;
        response = 'success';
      }
      notifyListeners();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  setIsEdit(bool value) {
    _isEdit = value;
    notifyListeners();
  }

  /// SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    required int role,
  }) async {
    _isLoading = true;
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // add user to your  fireStore database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'role': role,
        });

        res = "success";
        _isLoading = false;
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        _selectedRole = userDoc['role'];
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // for signout
  signOut() async {
    await _auth.signOut();
  }

  getUserRole() async {
    if (_auth.currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      _selectedRole = userDoc['role'];
    }
  }

  // get profile picture

  pickImage(ImageSource source, BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No Image is selected')));
    }
  }

  getImage(BuildContext context) async {
    Uint8List img =
        await ImagePickerHelper().pickImage(ImageSource.camera, context);
    _selectedImage = img;
    notifyListeners();
  }

  // save user data
  Future<String> saveImageData({required Uint8List file}) async {
    String response = 'Some error occurred';
    try {
      String imageUrl =
          await FirebaseHelper().uploadImageToStorage('profileImage', file);

      await _firestore
          .collection('user')
          .doc(_auth.currentUser?.uid ?? '')
          .update({'image': imageUrl});
      response = 'success';
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}
