import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'face_verification_service.dart';

enum FaceStatus { idle, scanning, success, failed }

class FaceVerificationController extends ChangeNotifier {
  final FaceVerificationService service;
  CameraController? cameraController;
  FaceStatus status = FaceStatus.idle;
  String message = 'Place your face in front of the camera';
  bool _isProcessing = false;
  double progress = 0.0;

  FaceVerificationController(this.service);

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front),
      ResolutionPreset.low,
      enableAudio: false,
    );
    await cameraController!.initialize();
    notifyListeners();
  }

  // Démarre la détection faciale avec animation de progression
  void startVerification(BuildContext context) async {
    if (status != FaceStatus.idle) return;

    status = FaceStatus.scanning;
    progress = 0.0;
    message = 'Scanning face...';
    notifyListeners();

    // Progression simulée sur 3 secondes
    const duration = 3000;
    const interval = 50;
    int ticks = duration ~/ interval;

    Timer.periodic(const Duration(milliseconds: interval), (timer) {
      progress += 1 / ticks;
      if (progress >= 1.0) progress = 1.0;
      notifyListeners();
      if (progress >= 1.0) timer.cancel();
    });

    cameraController?.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image);
        final faces = await service.detector.processImage(inputImage);

        if (faces.isNotEmpty) {
          status = FaceStatus.success;
          message = 'Face Detected!';
          progress = 1.0;
          notifyListeners();

          // Vibration courte de 200ms
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 200);
          }

          await cameraController?.stopImageStream();

          // Navigation après succès (exemple : Login)
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/Login');
          }

          // Réinitialisation automatique après 2 secondes
          Future.delayed(const Duration(seconds: 2), () {
            status = FaceStatus.idle;
            progress = 0.0;
            message = 'Place your face in front of the camera';
            notifyListeners();
          });
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
