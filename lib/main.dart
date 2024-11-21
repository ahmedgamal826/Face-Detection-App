import 'package:face_detection_app/face_detection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FaceDetectionApp());
}

class FaceDetectionApp extends StatelessWidget {
  const FaceDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FaceDetection(),
    );
  }
}
