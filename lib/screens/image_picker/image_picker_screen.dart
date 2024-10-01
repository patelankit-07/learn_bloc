import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahil_assignment/bloc/image_picker/image_picker_bloc.dart';
import 'package:sahil_assignment/bloc/image_picker/image_picker_event.dart';
import 'package:sahil_assignment/bloc/image_picker/image_picker_state.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker Bloc"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ImagePickerBloc, ImagePickerStates>(
              builder: (context, state) {
                return Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: state.file == null
                      ? const Icon(Icons.image, size: 100, color: Colors.grey)
                      : Image.file(File(state.file!.path), fit: BoxFit.cover),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ImagePickerBloc>().add(CameraCapture());
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ImagePickerBloc>().add(GalleryPicker());
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
