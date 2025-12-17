import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'face_verification_controller.dart';
import 'face_verification_service.dart';

class FaceVerificationScreen extends StatelessWidget {
  const FaceVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FaceVerificationController(FaceVerificationService())..initializeCamera(),
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          if (controller.cameraController?.value.isInitialized == true)
            Center(
              child: AspectRatio(
                aspectRatio: 1 / controller.cameraController!.value.aspectRatio,
                child: CameraPreview(controller.cameraController!),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Design Overlay (Le cercle)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(140)),
                  ),
                ),
              ],
            ),
          ),

          // Circle Border
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.status == FaceStatus.success ? Colors.green : Colors.blueAccent,
                  width: 4,
                ),
              ),
            ),
          ),

          // Bottom UI
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  controller.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                if (controller.status == FaceStatus.idle)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    onPressed: () => controller.startVerification(context),
                    child: const Text("Start Detection", style: TextStyle(color: Colors.white)),
                  ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () => SystemNavigator.pop(), // Bouton Quitter
                  child: const Text("Exit Application", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}