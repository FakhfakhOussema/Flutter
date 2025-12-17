import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'face_verification_service.dart';

enum FaceVerificationStatus {
  idle,
  scanning,
  success,
  failed,
}

class FaceVerificationController extends ChangeNotifier {
  final FaceVerificationService service;

  CameraController? cameraController;
  FaceVerificationStatus status = FaceVerificationStatus.idle;
  String message = 'Appuyez pour commencer la vérification';

  int attempts = 0;
  final int maxAttempts = 3;
  bool _isProcessing = false;

  FaceVerificationController(this.service);

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
      ),
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();
    notifyListeners();
  }

  void startVerification() {
    status = FaceVerificationStatus.scanning;
    message = 'Clignez des yeux ou tournez la tête';
    notifyListeners();

    cameraController?.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      final inputImage = _convertCameraImage(image);
      final faces =
      await service.detector.processImage(inputImage);

      final isHuman = await service.verifyLiveness(faces);

      if (isHuman) {
        status = FaceVerificationStatus.success;
        message = 'Vérification réussie';
        await cameraController?.stopImageStream();
      }

      _isProcessing = false;
      notifyListeners();
    });

    Timer(const Duration(seconds: 15), () {
      if (status == FaceVerificationStatus.scanning) {
        attempts++;
        status = FaceVerificationStatus.failed;
        message = 'Échec de la vérification';
        cameraController?.stopImageStream();
        notifyListeners();
      }
    });
  }

  void retry() {
    if (attempts >= maxAttempts) return;
    status = FaceVerificationStatus.idle;
    message = 'Réessayez la vérification';
    notifyListeners();
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
        rotation: InputImageRotation.rotation0deg,
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
