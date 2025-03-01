import 'package:flutter/material.dart';
import '../../cipher_codes/autokey.dart';

class AutoKeyCipher extends StatefulWidget {
  const AutoKeyCipher({super.key});

  @override
  State<AutoKeyCipher> createState() => _AutoKeyCipherState();
}

class _AutoKeyCipherState extends State<AutoKeyCipher> {
  final TextEditingController _cipherTextController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  final AutoKey _cipher = AutoKey();
  bool _showKeyError = false;
  bool decpressed  = false;
  String _keyErrorMessage = '';

  // Validate the key entered by user
  bool _validateKey() {
    if (_keyController.text.isEmpty) {
      setState(() {
        _showKeyError = true;
        _keyErrorMessage = 'Key cannot be empty';
      });
      return false;
    }

    // Check if key contains only alphabetic characters
    bool hasNonAlpha = _keyController.text.split('').any((char) => !_cipher.isAlpha(char));
    if (hasNonAlpha) {
      setState(() {
        _showKeyError = true;
        _keyErrorMessage = 'Key must contain only letters';
      });
      return false;
    }

    setState(() {
      _showKeyError = false;
    });
    return true;
  }

  // Handle decryption (decrypting the entered cipher text)
  void _handleDecrypt() {
    if (_cipherTextController.text.isEmpty || _keyController.text.isEmpty) return;

    if (!_validateKey()) {
      // Hide error after 2 seconds if there is any
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
    AutoKey.isUPP(_cipherTextController.text, _isUp);
    
    setState(() {
      _outputText = _cipher.decrypt(
        _cipherTextController.text,  // Use the encrypted text here
        _keyController.text,
        _isUp,  // Case information for decryption
      );
      _showOutput = true;
      decpressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AutoKey Cipher - Decrypt',
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
                controller: _cipherTextController,  // Input encrypted text here
                decoration: const InputDecoration(
                  labelText: 'Enter Encrypted Text',  // Changed to encrypted text label
                  hintText: 'Enter the encrypted text to decrypt',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: TextField(
                  controller: _keyController,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: 'Enter Key',
                    hintText: 'Enter alphabetic key',
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
                  onPressed: _handleDecrypt,  // Trigger decryption process
                  child: const Text(
                    "Decrypt Cipher Text",  // Button label for decryption
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
                    labelText: 'Decrypted Output',  // Output label after decryption
                    border: OutlineInputBorder(),
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
