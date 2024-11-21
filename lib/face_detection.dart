import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetection extends StatefulWidget {
  const FaceDetection({super.key});

  @override
  State<FaceDetection> createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  final ImagePicker imagePicker = ImagePicker();
  File? _image;
  List<Face> faces = [];

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      setState(() {
        _image = File(image.path);
      });

      // Detect faces after picking the image
      await detectFaces(_image!);
    } catch (e) {
      print('$e');
    }
  }

  Future<void> detectFaces(File img) async {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    );
    final faceDetector = FaceDetector(options: options);
    final inputImage = InputImage.fromFile(img);
    final detectedFaces = await faceDetector.processImage(inputImage);

    setState(() {
      faces = detectedFaces;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Face Detection',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey,
              child: Center(
                child: _image == null
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 40,
                      )
                    : CustomPaint(
                        foregroundPainter: FacePainter(faces),
                        child: Image.file(_image!),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.blue,
            onPressed: () => pickImage(ImageSource.camera),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pick Image from Camera',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.blue,
            onPressed: () => pickImage(ImageSource.gallery),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Pick Image from Gallery',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Number Of Persons: ${faces.length}',
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;

  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (Face face in faces) {
      final rect = face.boundingBox;
      canvas.drawRect(
        Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
