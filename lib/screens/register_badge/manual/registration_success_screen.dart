import 'package:flutter/material.dart';
import 'package:itrackcar/screens/main_navigation_screen.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final Map<String, String?> vehicleDetails;

  const RegistrationSuccessScreen({
    super.key,
    required this.vehicleDetails,
  });

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
                  icon: Icons.check_circle,
                  isActive: true,
                  isCompleted: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Success Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha((0.1 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          // Success Message
          const Text(
            'Vehicle registered successfully!',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The vehicle has successfully registered and linked\nto the tag',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Vehicle Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildDetailRow('VIN:', vehicleDetails['vin'] ?? ''),
                const SizedBox(height: 16),
                _buildDetailRow('Make:', vehicleDetails['make'] ?? ''),
                const SizedBox(height: 16),
                _buildDetailRow('Model:', vehicleDetails['model'] ?? ''),
                const SizedBox(height: 16),
                _buildDetailRow('Color:', vehicleDetails['color'] ?? ''),
                const SizedBox(height: 16),
                _buildDetailRow('Tag ID:', vehicleDetails['tagId'] ?? ''),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'Register time:',
                  DateTime.now().toString().substring(0, 16),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Submit Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainNavigationScreen()), (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit & Register another',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
} 