import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p8/provider/user_places.dart';
import 'package:p8/screens/tabs.dart';
import 'package:p8/widgets/post.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;

  void _savePlace() async {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty || _selectedImage == null) {
      // Notify the user if title or image is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a title and image.'),
        ),
      );
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(
          enteredTitle,
          _selectedImage!,
        );

    // Navigate back to the previous screen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => TabScreen(),
    ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              decoration: const InputDecoration(labelText: 'Caption'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 80),
            ImageInput(
              onPickimage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 160),
            ElevatedButton.icon(
              onPressed: _savePlace,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(75, 79, 126, 212),
              ),
              label: const Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
