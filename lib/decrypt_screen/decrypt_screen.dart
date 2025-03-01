
import 'package:cipherly/decrypt_screen/decryptscreens/additive_cipherde.dart';
import 'package:cipherly/decrypt_screen/decryptscreens/affine_cipherde.dart';
import 'package:cipherly/decrypt_screen/decryptscreens/autokey_cipherde.dart';
import 'package:cipherly/decrypt_screen/decryptscreens/multiplicative_cipherde.dart';
import 'package:cipherly/decrypt_screen/decryptscreens/transposition_combinedde.dart';
import 'package:cipherly/decrypt_screen/decryptscreens/transposition_keyedde.dart';
import 'package:cipherly/decrypt_screen/decryptscreens/transposition_keylessde.dart';
import 'package:cipherly/screens/copyrights.dart';
import 'package:flutter/material.dart';

class DecryptScreen extends StatelessWidget {
  const DecryptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const AdditiveCipher(),
      const MultiplicativeCipher(),
      const AffineCipher(),
      const AutoKeyCipher(),
      const KeylessTranspositionCipher(),
      const KeyedTranspositionCipher(),
      const CombinedTranspositionCipherWidget()
    ];

    List<String> names = [
      "Additive Cipher",
      "Multiplicative Cipher",
      "Affine Cipher",
      "Autokey Cipher",
      "Keyless Transposition",
      "Keyed Transposition",
      "Combined Transposition"
    ];
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double cardHeight = screenHeight * 0.1;
    double horizontalMargin = screenWidth * 0.03;
    double verticalMargin = screenHeight * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Decrypt Text',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.copyright,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CopyRights()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        child: Column(
          children: [
            Text(
              "Developed by: Waleed Qamar",
              style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: screens.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => screens[index]),
                      );
                    },
                    child: SizedBox(
                      height: cardHeight,
                      child: Card(
                        elevation: 5.0,
                        color: Colors.blueAccent,
                        margin: EdgeInsets.symmetric(
                          vertical: verticalMargin - 10,
                          horizontal: horizontalMargin,
                        ),
                        child: Center(
                          child: Text(
                            names[index],
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
