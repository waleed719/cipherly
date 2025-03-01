import 'package:flutter/material.dart';

import '../../cipher_codes/transpositionkeyed.dart';

class KeyedTranspositionCipher extends StatefulWidget {
  const KeyedTranspositionCipher({super.key});

  @override
  State<KeyedTranspositionCipher> createState() =>
      _KeyedTranspositionCipherState();
}

class _KeyedTranspositionCipherState
    extends State<KeyedTranspositionCipher> {
  final TextEditingController _textController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  List<int> _spaces = [];
  final KeyedTransPosition _cipher = KeyedTransPosition();

  // Handle Decryption: Convert encrypted text to original plaintext
  void _handleDecrypt() {
    if (_textController.text.isEmpty) return;

    _isUp = [];
    _spaces = [];
    KeyedTransPosition.isUPP(_textController.text, _isUp);
    _cipher.checkSpaces(_textController.text, _spaces);

    setState(() {
      try {
        // Make sure you are passing the correct cipher text.
        String encryptedText = _textController.text;
        debugPrint('Encrypted Text: $encryptedText');

        // Ensure that you handle the case sensitivity issue properly
        // You may want to try both uppercase and original text based on your cipher requirements
        String decrypted = _cipher.decrypt(encryptedText); // Don't force uppercase unless needed
        debugPrint('Decrypted Text: $decrypted');

        _outputText = _cipher.originalText(decrypted, _spaces, _isUp);
        debugPrint('Original Text (with spaces and case preserved): $_outputText');
        _showOutput = true;
      } catch (e) {
        debugPrint('Error during decryption: $e');
      }
    });
  }

  // Show the Key Structure Dialog
  void _showKeyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Key Structure'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'The cipher uses the following key for encryption and decryption:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assest/transposition_cipher_key.png',
                height: 150,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keyed Transposition Cipher',
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
                ElevatedButton(
                  onPressed: _showKeyDialog,
                  child: const Text('Show Key'),
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
