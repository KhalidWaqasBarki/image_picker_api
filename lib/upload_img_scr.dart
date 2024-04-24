import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageScr extends StatefulWidget {
  const UploadImageScr({super.key});

  @override
  State<UploadImageScr> createState() => _UploadImageScrState();
}

class _UploadImageScrState extends State<UploadImageScr> {
  File? image;
  final picker = ImagePicker();
  bool showSpinner = false;

  Future getImageByGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print('No image selected');
    }
  }

  Future getImageByCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print('No image selected');
    }
  }

  Future<void> UploadImage() async {
    setState(() {
      showSpinner = true;
    });

    var stream = new http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request = new http.MultipartRequest('POST', uri);

    request.fields['title'] = 'Static Title';
    var multiport = new http.MultipartFile('image', stream, length);
    request.files.add(multiport);
    var response = await request.send();
    if (response.statusCode == 200) {
      fluttertoast('Image Uploaded Successfully');
      showSpinner = false;
      setState(() {
      });
    } else {
      showSpinner = false;
fluttertoast('Failed to upload image');
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Upload Image',style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: (image == null
                      ? const Center(
                          child: Text('Upload image',style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      : Container(
                          child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                                            File(image!.path).absolute,
                                                            height: 400,
                                                            width: 400,
                                                            fit: BoxFit.cover
                                  ,
                                                          ),
                              )),
                        )),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200]),
                    onPressed: () {
                      getImageByGallery();
                    },
                    child: const Text(
                      'Upload image from gallery',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200]),
                    onPressed: () {
                      getImageByCamera();
                    },
                    child: const Text(
                      'Upload image from Camera',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: 40),
                ElevatedButton(

                    onPressed: () {
                      UploadImage();
                    },
                    child: const Text(
                      'Upload image to server',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fluttertoast(String message){
    Fluttertoast.showToast(msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.cyan[100],
      textColor: Colors.black

    );

  }
}

