import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidget();
}

class _ImagePickerWidget extends State<ImagePickerWidget> {
  File? _pickedImageFile;

  void _pickedImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'JOIN US !',
            style: TextStyle(
              color: Color.fromRGBO(24, 43, 78, 0.301),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: _pickedImage,
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 32,
                color: const Color.fromARGB(147, 66, 72, 75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
