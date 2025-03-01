import 'package:flutter/material.dart';

import '../../cipher_codes/transpositionkeyless.dart';

class KeylessTranspositionCipher extends StatefulWidget {
  const KeylessTranspositionCipher({super.key});

  @override
  State<KeylessTranspositionCipher> createState() =>
      _KeylessTranspositionCipherState();
}

class _KeylessTranspositionCipherState
    extends State<KeylessTranspositionCipher> {
  final TextEditingController _textController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  List<int> _spaces = [];
  final KeyLessTransPosition _cipher = KeyLessTransPosition();

  // Handle Decryption: Convert encrypted text to original plaintext
  void _handleDecrypt() {
    if (_textController.text.isEmpty) return;

    _isUp = [];
    _spaces = [];
    KeyLessTransPosition.isUPP(_textController.text, _isUp);
    _cipher.checkSpaces(_textController.text, _spaces);

    setState(() {
      try {
        String decrypted = _cipher.decrypt(_textController.text.toUpperCase());
        _outputText = _cipher.originalText(decrypted, _spaces, _isUp);
        _showOutput = true;
      } catch (e) {
        debugPrint('Error during decryption: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keyless Transposition Cipher',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter cipher text',
                    hintText: 'Enter the cipher text to decrypt',
                    border: OutlineInputBorder(),
                    helperText: 'Spaces and case will be preserved during decryption',
                    helperMaxLines: 2,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.none,
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
                if (_showOutput) ...[
                  const SizedBox(height: 40),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: _outputText),
                    decoration: const InputDecoration(
                      labelText: 'Decrypted Output',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
