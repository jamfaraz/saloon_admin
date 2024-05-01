
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

import '../../controllers/profile_controller.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String name = "";

  ProfileController profileController = Get.put(ProfileController());

  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
//
//
  File? _image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  Future<String> _uploadImage() async {
    String fileName = _image!.path.split('/').last;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('product_images/$fileName');
    await firebaseStorageRef.putFile(_image!);
    String imageUrl = await firebaseStorageRef.getDownloadURL();
    // imageUrl='';
    return imageUrl;
  }

  String imageaddress = "";
  String imagetoUpload = "";
  bool isAdding = false;
  bool isLoading = false;
  //
  //
  final _categories = <String>[
    'Simple hair cut',
    'shave',
    'Fancy hair cut',
    'Beared setting',
    'Hair and beared setting',
    'Facial massag',
    'complete massage',
  ];

  String? _category;

  void addPost(
      {required String price,
      required String address,
      required String category,
      required String contact}) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text('Please wait'), title: null);
    try {
      progressDialog.show();

      progressDialog.show();
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      var uuid = const Uuid();
      var myId = uuid.v6();
      String imageURL = await _uploadImage();

      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
          .instance
          .collection('barbars')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final data = document.data()!;
      String userName = data['username'];
      String image = data['image'];
      // String fcmToken = data['fcmToken'];
      //
      //
      await FirebaseFirestore.instance.collection('posts').doc(myId).set({
        'postId': myId,
        'userId': uid,
        'id': FirebaseAuth.instance.currentUser!.uid,
        'username': userName,
        'contact': contact,
        'image': image,
        'category': category,
        'address': address,
        'itemImage': imageURL,
        // 'fcmToken': fcmToken,
        'price': price,
        'time': DateTime.now(),
      });
      priceController.clear();
      addressController.clear();
      contactController.clear();
      _image = null;

      progressDialog.dismiss();

      Fluttertoast.showToast(msg: 'Your post added sucessfully');
    } catch (e) {
      progressDialog.dismiss();

      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Add post',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 22,
                ),
                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    height: Get.height * .2,
                    width: Get.size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromARGB(255, 231, 231, 231)),
                    child: Center(
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image!,
                                height: Get.height * .2,
                                width: Get.size.width,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Package',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.030,
                        horizontal: 9),
                    // prefixIcon: const Icon(Icons.category, color: Colors.black),
                    hintText: 'Select package',
                    prefixIcon: const Icon(Icons.category, color: Colors.green),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black45,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      color: Color(0xFF828A89),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  items: _categories
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Price',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: priceController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF828A89),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon:
                          const Icon(Icons.numbers, color: Colors.green),
                      isDense: true,
                      hintText: 'Enter package price',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Address',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: addressController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF828A89),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon:
                          const Icon(Icons.location_pin, color: Colors.green),
                      isDense: true,
                      hintText: 'Enter your address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: contactController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF828A89),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(Icons.phone, color: Colors.green),
                      hintText: 'Enter your contact',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: Get.height * .08,
                ),
                InkWell(
                  onTap: () async {
                    if (_image == null ||
                        priceController.text.isEmpty ||
                        contactController.text.isEmpty ||
                        _category.toString().isEmpty ||
                        addressController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter all details",
                      );
                    } else {
                      addPost(
                        price: priceController.text,
                        address: addressController.text,
                        category: _category.toString(),
                        contact: contactController.text,
                      );
                      //
                      // //

                      //
                      //
                    }
                  },
                  child: Container(
                    height: 49,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Add Post',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
