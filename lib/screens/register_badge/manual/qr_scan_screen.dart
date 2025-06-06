import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:io';
import 'registration_success_screen.dart';

class QRScanScreen extends StatefulWidget {
  final Map<String, String?> vehicleDetails;

  const QRScanScreen({
    super.key,
    required this.vehicleDetails,
  });

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isScanning = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (_isScanning && scanData.code != null) {
        setState(() {
          _isScanning = false;
        });
        
        // Add the Tag ID to vehicle details
        final updatedDetails = Map<String, String?>.from(widget.vehicleDetails);
        updatedDetails['tagId'] = scanData.code;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationSuccessScreen(
              vehicleDetails: updatedDetails,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2632),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manual registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildStepCircle(
                  icon: Icons.numbers,
                  isActive: false,
                  isCompleted: true,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey[700],
                  ),
                ),
                _buildStepCircle(
                  icon: Icons.qr_code,
                  isActive: true,
                  isCompleted: false,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey[700],
                  ),
                ),
                _buildStepCircle(
                  icon: Icons.check_circle,
                  isActive: false,
                  isCompleted: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scan QR Tag to link vehicle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.white,
                    borderRadius: 16,
                    borderLength: 24,
                    borderWidth: 4,
                    cutOutSize: 300,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'The QR code will be detected automatically\nwhen placed within the guide lines.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required IconData icon,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? Colors.white
            : isCompleted
                ? Colors.green
                : Colors.grey[700],
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.white,
        size: 18,
      ),
    );
  }
} 