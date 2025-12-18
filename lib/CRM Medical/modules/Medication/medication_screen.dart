import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';
import '../MLKit/barcode_scanning/barcode_scanning_view.dart';
import 'package:vibration/vibration.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  /// Modal pour ajouter un médicament
  void _showAddMedicationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a Medication',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Nom médicament
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
              const SizedBox(height: 20),

              // Code-barres (manuel ou scan)
              TextField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  labelText: 'Code-barres',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.qr_code),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      final barcode = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BarcodeScannerView()),
                      );
                      if (barcode != null) {
                        setState(() {
                          _barcodeController.text = barcode;
                        });
                        if (await Vibration.hasVibrator() ?? false) {
                          Vibration.vibrate(duration: 200); // vibration 200ms
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quantité
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty || _quantityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill out all the fields')),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance.collection('medications').add({
                    'name': _nameController.text.trim(),
                    'barcode': _barcodeController.text.trim(),
                    'quantity': int.tryParse(_quantityController.text.trim()) ?? 0,
                    'createdAt': Timestamp.now(),
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Medication added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _nameController.clear();
                  _barcodeController.clear();
                  _quantityController.clear();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Scanner un code QR pour rechercher un médicament
  void _searchMedicationByBarcode() async {
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerView()),
    );

    if (barcode != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;

        // Vibration courte à chaque scan réussi
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 200); // vibration 200ms
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(doc['name']),
            content: Text('Quantity : ${doc['quantity']}\nCode-barres : ${doc['barcode']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication not found')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Médicaments'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Aucun médicament ajouté',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blue),
                  title: Text(doc['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (doc['barcode'] != null && doc['barcode'] != '')
                        Text('Code-barres : ${doc['barcode']}'),
                      Text('Quantité : ${doc['quantity']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('medications').doc(doc.id).delete();
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showAddMedicationModal(context),
            backgroundColor: Colors.green,
            tooltip: 'Ajouter un médicament',
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'search',
            onPressed: _searchMedicationByBarcode,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            tooltip: 'Rechercher par code-barres',
          ),
        ],
      ),
    );
  }
}
