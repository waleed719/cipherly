import 'package:flutter/material.dart';
import '../../cipher_codes/affine.dart';

class AffineCipher extends StatefulWidget {
  const AffineCipher({super.key});

  @override
  State<AffineCipher> createState() => _AffineCipherState();
}

class _AffineCipherState extends State<AffineCipher> {
  final TextEditingController _cipherTextController = TextEditingController();
  final TextEditingController _key1Controller = TextEditingController();
  final TextEditingController _key2Controller = TextEditingController();
  bool _showOutput = false;
  String _outputText = '';
  List<bool> _isUp = [];
  final Affine _cipher = Affine();
  bool _showKey1Error = false;
  bool _showKey2Error = false;
  String _key1ErrorMessage = '';
  String _key2ErrorMessage = '';

  // Validate the keys entered
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
        _key1ErrorMessage = 'Key1 must have a multiplicative inverse mod 26';
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

  // Handle decryption (using the entered cipher text)
  void _handleDecrypt() {
    if (_cipherTextController.text.isEmpty || 
        _key1Controller.text.isEmpty || 
        _key2Controller.text.isEmpty) return;

    if (!_validateKeys()) return;

    int key1 = int.parse(_key1Controller.text);
    int key2 = int.parse(_key2Controller.text);

    // Now decrypt the entered cipher text
    setState(() {
      _outputText = _cipher.decrypt(
        _cipherTextController.text.toUpperCase(),  // Using cipher text as input
        key1,
        key2,
        _isUp,  // Use the list to store upper/lower case info if needed
      );
      _showOutput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Affine Cipher - Decrypt',
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
                  controller: _cipherTextController,  // Input the encrypted text here
                  decoration: const InputDecoration(
                    labelText: 'Enter Encrypted Text',  // Updated label
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
                    onPressed: _handleDecrypt,  // Trigger decryption instead
                    child: const Text(
                      "Decrypt Cipher Text",  // Button label
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
                      labelText: 'Decrypted Output',  // Updated label
                      border: OutlineInputBorder(),
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
    _cipherTextController.dispose();
    _key1Controller.dispose();
    _key2Controller.dispose();
    super.dispose();
  }
}
