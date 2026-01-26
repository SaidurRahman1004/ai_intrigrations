import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AIMethodsDemo extends StatefulWidget {
  const AIMethodsDemo({super.key});

  @override
  State<AIMethodsDemo> createState() => _AIMethodsDemoState();
}

class _AIMethodsDemoState extends State<AIMethodsDemo> {
  String result = 'Select an AI method';
  File? selectedImage;

  Future<void> runOnDeviceAi() async {
    setState(() {
      result = "Running On‑device AI...";
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      result = "On‑device: I don't know, I am on device.";
    });
  }

  Future<void> runCloudAI() async {
    setState(() {
      result = "Running Cloud AI...";
    });
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      result = "Cloud AI: Result from the cloud.";
    });
  }

  Future<void> runHybridAI() async {
    bool hasInternet = true;
    if (hasInternet) {
      await runCloudAI();
    } else {
      await runOnDeviceAi();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Simulation Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: selectedImage == null
                        ? Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Image.file(
                            selectedImage!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  ListTile(
                    title: const Text('Image Selection'),
                    subtitle: Text(
                      selectedImage == null
                          ? 'No image selected'
                          : 'Image loaded successfully',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: pickImage,
                      tooltip: 'Pick Image',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose an AI Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: runOnDeviceAi,
                  icon: const Icon(Icons.dns),
                  label: const Text('On‑device AI'),
                ),
                ElevatedButton.icon(
                  onPressed: runCloudAI,
                  icon: const Icon(Icons.cloud_queue),
                  label: const Text('Cloud AI'),
                ),
                ElevatedButton.icon(
                  onPressed: runHybridAI,
                  icon: const Icon(Icons.all_inclusive),
                  label: const Text('Hybrid AI'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
