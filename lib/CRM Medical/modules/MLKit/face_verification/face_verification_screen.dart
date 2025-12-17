import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';

/// Service ML Kit pour détecter le visage et faire le liveness check
class FaceVerificationService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  /// Vérifie si la personne effectue une action (cligner, tourner la tête, sourire)
  Future<bool> verifyLiveness(List<Face> faces) async {
    if (faces.isEmpty) return false;

    final Face face = faces.first;

    final bool eyesClosed =
        (face.leftEyeOpenProbability ?? 1.0) < 0.4 &&
            (face.rightEyeOpenProbability ?? 1.0) < 0.4;

    final bool headTurned =
        (face.headEulerAngleY ?? 0).abs() > 15;

    final bool smiling =
        (face.smilingProbability ?? 0) > 0.6;

    return eyesClosed || headTurned || smiling;
  }

  FaceDetector get detector => _faceDetector;

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}

/// Controller pour gérer l'état de la vérification faciale
enum FaceVerificationStatus { idle, scanning, success, failed }

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
      final faces = await service.detector.processImage(inputImage);

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

/// Page UI pour la vérification faciale
class FaceVerificationScreen extends StatelessWidget {
  const FaceVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FaceVerificationController(
        FaceVerificationService(),
      )..initializeCamera(),
      child: const _FaceVerificationView(),
    );
  }
}

class _FaceVerificationView extends StatelessWidget {
  const _FaceVerificationView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FaceVerificationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Vérification humaine')),
      body: Column(
        children: [
          Expanded(
            child: controller.cameraController?.value.isInitialized == true
                ? CameraPreview(controller.cameraController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  controller.message,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),

                if (controller.status == FaceVerificationStatus.idle)
                  ElevatedButton(
                    onPressed: controller.startVerification,
                    child: const Text('Démarrer la vérification'),
                  ),

                if (controller.status == FaceVerificationStatus.success)
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, '/Login'),
                    child: const Text('Continuer'),
                  ),

                if (controller.status == FaceVerificationStatus.failed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: controller.retry,
                        child: const Text('Réessayer'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Quitter'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
