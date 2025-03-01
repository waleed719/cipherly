import 'package:flutter/material.dart';

import '../../cipher_codes/autokey.dart';

class AutoKeyCipher extends StatefulWidget {
  const AutoKeyCipher({super.key});

  @override
  State<AutoKeyCipher> createState() => _AutoKeyCipherState();
}

class _AutoKeyCipherState extends State<AutoKeyCipher> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  final AutoKey _cipher = AutoKey();
  bool _showKeyError = false;
  bool decpressed  = false;
  String _keyErrorMessage = '';

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

  void _handleEncrypt() {
    if (_textController.text.isEmpty || _keyController.text.isEmpty) return;
    
    if (!_validateKey()) {
      // Hide error after 2 seconds
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
    AutoKey.isUPP(_textController.text, _isUp);
    
    setState(() {
      _outputText = _cipher.encrypt(
        _textController.text,
        _keyController.text,
      );
      _showOutput = true;
      decpressed = false;
    });
  }

  void _handleDecrypt() {
    if(decpressed == false){
      setState(() {
      _outputText = _cipher.decrypt(
        _outputText,
        _keyController.text,
        _isUp,
      );
    });
    }
    decpressed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AutoKey Cipher',
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
                  hintText: 'Enter the text to encrypt/decrypt',
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
                  onPressed: _handleEncrypt,
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