import 'package:flutter/material.dart';

import '../../cipher_codes/transpositionkeyed.dart';



class KeyedTranspositionCipher extends StatefulWidget {
  const KeyedTranspositionCipher({super.key});

  @override
  State<KeyedTranspositionCipher> createState() => _KeyedTranspositionCipherState();
}

class _KeyedTranspositionCipherState extends State<KeyedTranspositionCipher> {
  final TextEditingController _textController = TextEditingController();
  bool _showOutput = false;
  bool _decPressed = false;
  String _outputText = '';
  List<bool> _isUp = [];
  List<int> _spaces = [];
  final KeyedTransPosition _cipher = KeyedTransPosition();

  void _handleEncrypt() {
    if (_textController.text.isEmpty) return;

    _isUp = [];
    _spaces = [];
    KeyedTransPosition.isUPP(_textController.text, _isUp);
    _cipher.checkSpaces(_textController.text, _spaces);

    setState(() {
      _outputText = _cipher.encrypt(_textController.text);
      _showOutput = true;
      _decPressed = false;
    });
  }

  void _handleDecrypt() {
    if (!_decPressed) {
      try {
        // Debug logs
        debugPrint('Encrypted Text: $_outputText');
        debugPrint('Spaces: $_spaces');
        debugPrint('IsUpperCase List: $_isUp');

        String decrypted = _cipher.decrypt(_outputText);
        debugPrint('Decrypted Text: $decrypted');

        String original = _cipher.originalText(decrypted, _spaces, _isUp);
        debugPrint('Original Text: $original');

        setState(() {
          _outputText = original;
        });

        _decPressed = true;
      } catch (e) {
        debugPrint('Error during decryption: $e');
      }
    }
  }

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
                    labelText: 'Enter text',
                    hintText: 'Text will be processed in blocks of 5 characters',
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
                    maxLines: 3,
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
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
