import 'package:flutter/material.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final Map<String, String> vehicleInfo;

  const RegistrationSuccessScreen({
    super.key,
    required this.vehicleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manual registration'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepIcon(icon: Icons.document_scanner),
              _buildStepIcon(icon: Icons.qr_code_scanner),
              _buildStepIcon(icon: Icons.check_circle_outline, isActive: true),
            ],
          ),
          const SizedBox(height: 40),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'Vehicle registered successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This vehicle has been successfully registered and linked.',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildInfoRow('VIN:', vehicleInfo['vin'] ?? ''),
                  _buildInfoRow('Make:', vehicleInfo['make'] ?? ''),
                  _buildInfoRow('Model:', vehicleInfo['model'] ?? ''),
                  _buildInfoRow('Color:', vehicleInfo['color'] ?? ''),
                  _buildInfoRow('Tag ID:', vehicleInfo['tagId'] ?? ''),
                  _buildInfoRow('Register time:', vehicleInfo['registerTime'] ?? ''),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the register badge screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Submit & Register another'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon({
    required IconData icon,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey,
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }
} 