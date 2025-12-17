import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'face_verification_service.dart';

enum FaceStatus { idle, scanning, success }

class FaceVerificationController extends ChangeNotifier {
  final FaceVerificationService service;
  CameraController? cameraController;
  FaceStatus status = FaceStatus.idle;
  String message = 'Place your face in front of the camera';
  bool _isProcessing = false;

  FaceVerificationController(this.service);

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front),
      ResolutionPreset.low, // Basse résolution pour plus de rapidité
      enableAudio: false,
    );
    await cameraController!.initialize();
    notifyListeners();
  }

  void startVerification(BuildContext context) {
    status = FaceStatus.scanning;
    message = 'Scanning face...';
    notifyListeners();

    cameraController?.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        final faces = await service.detector.processImage(inputImage);

        // CONDITION SIMPLE : Si un visage est détecté
        if (faces.isNotEmpty) {
          status = FaceStatus.success;
          message = 'Face Detected!';
          notifyListeners();

          await cameraController?.stopImageStream();

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/Login');
          }
        }
      } catch (e) {
        debugPrint("Error: $e");
      } finally {
        _isProcessing = false;
      }
    });
  }

  InputImage _convertCameraImage(CameraImage image) {
    final WriteBuffer buffer = WriteBuffer();
    for (final plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    final bytes = buffer.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation270deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    service.dispose();
    super.dispose();
  }
}