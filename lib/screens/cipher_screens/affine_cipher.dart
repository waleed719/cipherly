import 'package:flutter/material.dart';

import '../../cipher_codes/affine.dart';

class AffineCipher extends StatefulWidget {
  const AffineCipher({super.key});

  @override
  State<AffineCipher> createState() => _AffineCipherState();
}

class _AffineCipherState extends State<AffineCipher> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _key1Controller = TextEditingController();
  final TextEditingController _key2Controller = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  final Affine _cipher = Affine();
  bool _showKey1Error = false;
  bool _showKey2Error = false;
  bool decpressed = false;
  String _key1ErrorMessage = '';
  String _key2ErrorMessage = '';

  bool _validateKeys() {
    bool isValid = true;
    int key1 = int.tryParse(_key1Controller.text) ?? -1;
    int key2 = int.tryParse(_key2Controller.text) ?? -1;

    // Validate key1 (multiplicative key)
    if (key1 <= 0 || key1 >= 26) {
      setState(() {
        _showKey1Error = true;
        _key1ErrorMessage = 'Key1 must be between 1 and 25';
      });
      isValid = false;
    } else if (_cipher.isInverse(key1) == -1) {
      setState(() {
        _showKey1Error = true;
        _key1ErrorMessage = 'Key must have a multiplicative inverse mod 26\n numbers that have multiplicative inverse in range 1-25 are\n 1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25';

      });
      isValid = false;
    } else {
      setState(() {
        _showKey1Error = false;
      });
    }

    // Validate key2 (additive key)
    if (key2 < 0 || key2 >= 26) {
      setState(() {
        _showKey2Error = true;
        _key2ErrorMessage = 'Key2 must be between 0 and 25';
      });
      isValid = false;
    } else {
      setState(() {
        _showKey2Error = false;
      });
    }

    // Hide errors after 2 seconds if there are any
    if (!isValid) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showKey1Error = false;
            _showKey2Error = false;
          });
        }
      });
    }

    return isValid;
  }

  void _handleEncrypt() {
    if (_textController.text.isEmpty || 
        _key1Controller.text.isEmpty || 
        _key2Controller.text.isEmpty) return;
    
    if (!_validateKeys()) return;

    int key1 = int.parse(_key1Controller.text);
    int key2 = int.parse(_key2Controller.text);
    
    _isUp = [];
    Affine.isUPP(_textController.text, _isUp);
    
    setState(() {
      _outputText = _cipher.encrypt(
        _textController.text,
        key1,
        key2,
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
        int.parse(_key1Controller.text),
        int.parse(_key2Controller.text),
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
          'Affine Cipher',
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
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: TextField(
                    controller: _key1Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Key1 (Multiplicative)',
                      border: const OutlineInputBorder(),
                      errorText: _showKey1Error ? _key1ErrorMessage : null,
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: TextField(
                    controller: _key2Controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Key2 (Additive)',
                      border: const OutlineInputBorder(),
                      errorText: _showKey2Error ? _key2ErrorMessage : null,
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
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _key1Controller.dispose();
    _key2Controller.dispose();
    super.dispose();
  }
}