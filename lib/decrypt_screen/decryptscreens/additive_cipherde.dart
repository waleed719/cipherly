import 'package:flutter/material.dart';

import '../../cipher_codes/additive.dart';

class AdditiveCipher extends StatefulWidget {
  const AdditiveCipher({super.key});

  @override
  State<AdditiveCipher> createState() => _AdditiveCipherState();
}

class _AdditiveCipherState extends State<AdditiveCipher> {
  final TextEditingController _cipherTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  final Additive _cipher = Additive();
  bool _showKeyError = false;
  bool encPressed = false;
  String _keyErrorMessage = '';
  String _originalText = '';  // Store original input

  void _validateAndDecrypt() {
    if (_cipherTextController.text.isEmpty || _keyController.text.isEmpty) return;

    int key = int.tryParse(_keyController.text) ?? -1;
    if (key < 0 || key > 25) {
      setState(() {
        _showKeyError = true;
        _keyErrorMessage = 'Key must be between 0 and 25';
      });

      // Hide the error message after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showKeyError = false;
          });
        }
      });

      return;
    }

    _isUp = [];
    _originalText = _cipherTextController.text;
    Additive.isUPP(_cipherTextController.text, _isUp);


    setState(() {
      _outputText = _cipher.decrypt(
        _cipherTextController.text.toUpperCase(),
        key,
        _isUp,
      );
      _showOutput = true;
      encPressed = false;
    });
  }

  void _handleEncrypt() {
    if (!encPressed) {
      int? key = int.tryParse(_keyController.text);
      if (key == null || key < 0 || key > 25) return;

      setState(() {
        // When encrypting back, we want to get our original input
        _outputText = _originalText;
        encPressed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Additive Cipher',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _cipherTextController,
                decoration: const InputDecoration(
                  labelText: 'Enter encrypted text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: TextField(
                  controller: _keyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Key',
                    border: const OutlineInputBorder(),
                    errorText: _showKeyError ? _keyErrorMessage : null,
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: _validateAndDecrypt,
                  child: const Text(
                    "Decrypt Text",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (_showOutput) ...[
                const SizedBox(height: 40),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: _outputText),
                  decoration: const InputDecoration(
                    labelText: 'Decrypted Output',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: _handleEncrypt,
                    child: const Text(
                      "Show Original Text",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cipherTextController.dispose();
    _keyController.dispose();
    super.dispose();
  }
}