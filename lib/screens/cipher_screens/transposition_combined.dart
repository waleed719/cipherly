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
  final TextEditingController _textController = TextEditingController();
  bool _showOutput = false;
  bool decpressed = false;
  String _outputText = '';
  List<bool> _isUp = [];
  List<int> _spaces = [];
  final CombinedTransPosition _cipher = CombinedTransPosition();

  void _handleEncrypt() {
    if (_textController.text.isEmpty) return;

    _isUp = [];
    _spaces = [];
    CombinedTransPosition.isUPP(_textController.text, _isUp);
    _cipher.checkSpaces(_textController.text, _spaces);

    setState(() {
      _outputText = _cipher.encrypt(_textController.text);
      _showOutput = true;
      decpressed = false;
    });
  }

  void _handleDecrypt() {
    if (decpressed == false) {
      setState(() {
        String decrypted = _cipher.decrypt(_outputText);
        _outputText = _cipher.originalText(decrypted, _spaces, _isUp);
      });
      decpressed = true;
    }
  }

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
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter text',
                    hintText: 'Text will be processed in blocks of 5 characters',
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
                    onPressed: _handleEncrypt,
                    child: const Text(
                      "Encrypt",
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
    _textController.dispose();
    super.dispose();
  }
}
