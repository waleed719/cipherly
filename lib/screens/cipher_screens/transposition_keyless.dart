import 'package:flutter/material.dart';

import '../../cipher_codes/transpositionkeyless.dart';

class KeylessTranspositionCipher extends StatefulWidget {
  const KeylessTranspositionCipher({super.key});

  @override
  State<KeylessTranspositionCipher> createState() => _KeylessTranspositionCipherState();
}

class _KeylessTranspositionCipherState extends State<KeylessTranspositionCipher> {
  final TextEditingController _textController = TextEditingController();
  bool _showOutput = false;
  bool decpressed = false;
  String _outputText = '';
  List<bool> _isUp = [];
  List<int> _spaces = [];
  final KeyLessTransPosition _cipher = KeyLessTransPosition();

  void _handleEncrypt() {
    if (_textController.text.isEmpty) return;
    
    _isUp = [];
    _spaces = [];
    KeyLessTransPosition.isUPP(_textController.text, _isUp);
    _cipher.checkSpaces(_textController.text, _spaces);
    
    setState(() {
      _outputText = _cipher.encrypt(_textController.text);
      _showOutput = true;
      decpressed = false;
    });
  }

  void _handleDecrypt() {
      if(decpressed == false){
        setState(() {
        String decrypted = _cipher.decrypt(_outputText);
        _outputText = _cipher.originalText(decrypted, _spaces, _isUp);
      });
      decpressed = true;
      }
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
                    labelText: 'Enter text',
                    hintText: 'Text will be processed in blocks of 4 characters',
                    border: OutlineInputBorder(),
                    helperText: 'Spaces and case will be preserved during decryption',
                    helperMaxLines: 2,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.none,
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