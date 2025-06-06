import 'package:flutter/material.dart';
import 'qr_scan_screen.dart';

class ManualRegistrationScreen extends StatefulWidget {
  const ManualRegistrationScreen({super.key});

  @override
  State<ManualRegistrationScreen> createState() => _ManualRegistrationScreenState();
}

class _ManualRegistrationScreenState extends State<ManualRegistrationScreen> {
  final _vinController = TextEditingController();
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedColor;

  final List<String> _makes = ['AUDI', 'BMW', 'MERCEDES', 'VOLKSWAGEN'];
  final List<String> _models = ['A1', 'A3', 'A4', 'A5', 'Q3', 'Q5'];
  final List<String> _colors = ['Black', 'White', 'Red', 'Blue', 'Silver'];

  @override
  void dispose() {
    _vinController.dispose();
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
                  icon: Icons.qr_code,
                  isActive: false,
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
                  'Enter vehicle detail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // VIN Input
                TextField(
                  controller: _vinController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'VIN',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF2D3545),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Make Dropdown
                _buildDropdown(
                  hint: 'Select make',
                  value: _selectedMake,
                  items: _makes,
                  onChanged: (value) {
                    setState(() {
                      _selectedMake = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Model Dropdown
                _buildDropdown(
                  hint: 'Select model',
                  value: _selectedModel,
                  items: _models,
                  onChanged: (value) {
                    setState(() {
                      _selectedModel = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Color Dropdown
                _buildDropdown(
                  hint: 'Select color',
                  value: _selectedColor,
                  items: _colors,
                  onChanged: (value) {
                    setState(() {
                      _selectedColor = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          // Next Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScanScreen(
                            vehicleDetails: {
                              'vin': _vinController.text,
                              'make': _selectedMake,
                              'model': _selectedModel,
                              'color': _selectedColor,
                            },
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: _isFormValid() ? Colors.black : Colors.grey[400],
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

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3545),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey[400]),
        ),
        isExpanded: true,
        dropdownColor: const Color(0xFF2D3545),
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  bool _isFormValid() {
    return _vinController.text.isNotEmpty &&
        _selectedMake != null &&
        _selectedModel != null &&
        _selectedColor != null;
  }
} 