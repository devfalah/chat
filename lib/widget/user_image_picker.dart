import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagPckfn;

  UserImagePicker(this.imagPckfn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final ImagePicker _imagePicker = ImagePicker();
  void _pickImage(ImageSource imageSource) async {
    final pickedImageFile = await _imagePicker.getImage(
      source: imageSource,
      imageQuality: 70,
      maxWidth: 300,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagPckfn(_pickedImage);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 80,
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage) : null,
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.photo_camera_outlined),
                label: Text(
                  "Add Image\nfrom Camera",
                  textAlign: TextAlign.center,
                ),
                textColor: Colors.white,
              ),
              FlatButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.image_outlined),
                label: Text(
                  "Add Image\nfrom Gallery",
                  textAlign: TextAlign.center,
                ),
                textColor: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}
