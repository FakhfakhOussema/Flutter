import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceVerificationService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

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
