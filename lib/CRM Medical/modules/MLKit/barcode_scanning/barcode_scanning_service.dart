import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeService {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  Future<String?> scanImage(InputImage inputImage) async {
    final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      // Retourne la valeur texte du premier code-barres trouvé
      return barcodes.first.displayValue;
    }
    return null;
  }

  void dispose() {
    _barcodeScanner.close();
  }
}