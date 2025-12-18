import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceVerificationService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  FaceDetector get detector => _faceDetector;

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}