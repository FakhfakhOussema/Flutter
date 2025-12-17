import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:flutter/foundation.dart';
import 'barcode_scanning_service.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  CameraController? _controller;
  final BarcodeService _barcodeService = BarcodeService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();

    _controller!.startImageStream((image) async {
      if (_isScanning) return;
      _isScanning = true;

      final inputImage = _convertImage(image);
      final barcode = await _barcodeService.scanImage(inputImage);

      if (barcode != null && mounted) {
        _controller!.stopImageStream();
        Navigator.pop(context, barcode); // Retourne le code à la page précédente
      }
      _isScanning = false;
    });
    setState(() {});
  }

  InputImage _convertImage(CameraImage image) {
    final WriteBuffer buffer = WriteBuffer();
    for (final plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    return InputImage.fromBytes(
      bytes: buffer.done().buffer.asUint8List(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation90deg, // Rotation normale pour caméra arrière
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _barcodeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Align Barcode")),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          // Overlay visuel pour aider le scan
          Center(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}