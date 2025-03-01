import 'package:flutter/material.dart';

import '../../cipher_codes/multiplicative.dart';

class MultiplicativeCipher extends StatefulWidget {
  const MultiplicativeCipher({super.key});

  @override
  State<MultiplicativeCipher> createState() => _MultiplicativeCipherState();
}

class _MultiplicativeCipherState extends State<MultiplicativeCipher> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  final Multiplicative _cipher = Multiplicative();
  bool _showKeyError = false;
  bool decpressed = false;
  String _keyErrorMessage = '';

  bool _isValidKey(int key) {
    if (key <= 0 || key >= 26) {
      setState(() {
        _showKeyError = true;
        _keyErrorMessage = 'Key must be between 1 and 25';
      });
      return false;
    }

    int inverse = _cipher.modInverse(key);
    if (inverse == -1) {
      setState(() {
        _showKeyError = true;
        _keyErrorMessage = 'Key must have a multiplicative inverse mod 26\n numbers that have multiplicative inverse in range 1-25 are\n 1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25';
      });
      return false;
    }

    return true;
  }

  void _validateAndEncrypt() {
    if (_textController.text.isEmpty || _keyController.text.isEmpty) return;
    
    int key = int.tryParse(_keyController.text) ?? -1;
    if (!_isValidKey(key)) {
      // Hide the error message after 2 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showKeyError = false;
          });
        }
      });
      return;
    }

    _isUp = [];
    Multiplicative.isUPP(_textController.text, _isUp);
    
    setState(() {
      _outputText = _cipher.encrypt(
        _textController.text,
        key,
      );
      _showOutput = true;
      decpressed = false;
    });
  }

  void _handleDecrypt() {
    if (decpressed == false) {
      setState(() {
        _outputText = _cipher.decrypt(
          _outputText,
          int.parse(_keyController.text),
          _isUp,
        );
      });
      decpressed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Multiplicative Cipher',
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
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter text',
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
                  onPressed: _validateAndEncrypt,
                  child: const Text(
                    "Convert to Cipher",
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
                    labelText: 'Output',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: _handleDecrypt,
                    child: const Text(
                      "Decrypt",
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
    _textController.dispose();
    _keyController.dispose();
    super.dispose();
  }
}