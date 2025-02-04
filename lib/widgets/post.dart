import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickimage});
  final void Function(File image) onPickimage;

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takepic() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onPickimage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: Icon(Icons.photo_library),
      onPressed: _takepic,
      label: Text('Gallary'),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takepic,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
            ),
          ),
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          child: content),
    );
  }
}
