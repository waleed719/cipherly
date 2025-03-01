import 'package:flutter/material.dart';
import '../../cipher_codes/transpositioncombined.dart';

class CombinedTranspositionCipherWidget extends StatefulWidget {
  const CombinedTranspositionCipherWidget({super.key});

  @override
  State<CombinedTranspositionCipherWidget> createState() =>
      _CombinedTranspositionCipherWidgetState();
}

class _CombinedTranspositionCipherWidgetState
    extends State<CombinedTranspositionCipherWidget> {
  final TextEditingController _cipherTextController = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  List<int> _spaces = [];
  final CombinedTransPosition _cipher = CombinedTransPosition();

  // Handle Decryption: Convert encrypted text to original plaintext
  void _handleDecrypt() {
    if (_cipherTextController.text.isEmpty) return;

    _isUp = [];
    _spaces = [];
    CombinedTransPosition.isUPP(_cipherTextController.text, _isUp);
    _cipher.checkSpaces(_cipherTextController.text, _spaces);

    setState(() {
      String decrypted = _cipher.decrypt(_cipherTextController.text.toUpperCase());
      _outputText = _cipher.originalText(decrypted, _spaces, _isUp);
      _showOutput = true;
    });
  }

  // Show the Cipher Key
  void _showKey() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cipher Key"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("The following key is used for the cipher:"),
              const SizedBox(height: 30),
              Image.asset(
                'assest/transposition_cipher_key.png',
                height: 150,
                fit: BoxFit.contain,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
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
          'Combined Transposition Cipher',
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
                  controller: _cipherTextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter cipher text',
                    hintText: 'Enter the cipher text to decrypt',
                    border: OutlineInputBorder(),
                    helperText:
                        'Spaces and case will be preserved during decryption',
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
                  const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: _showKey,
                    child: const Text(
                      "Show Key",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cipherTextController.dispose();
    super.dispose();
  }
}
