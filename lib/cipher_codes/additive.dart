class Additive {
  String encrypt(String plaintext, int key) {
    String ciphertext = "";
    for (int i = 0; i < plaintext.length; i++) {
      String c = plaintext[i];
      if (_isAlpha(c)) {
        c = c.toUpperCase();
        ciphertext += String.fromCharCode(((c.codeUnitAt(0) - 'A'.codeUnitAt(0) + key) % 26) + 'A'.codeUnitAt(0));
      } else {
        ciphertext += c;
      }
    }
    return ciphertext;
  }

  String decrypt(String ciphertext, int key, List<bool> isUp) {
    String plaintext = "";

    for (int i = 0; i < ciphertext.length; i++) {
      String c = ciphertext[i];
      if (_isAlpha(c)) {
        plaintext += String.fromCharCode(((c.codeUnitAt(0) - 'A'.codeUnitAt(0) - key + 26) % 26) + 'A'.codeUnitAt(0));
      } else {
        plaintext += c;
      }
    }

    for (int i = 0; i < plaintext.length; i++) {
      if (isUp[i]) {
        plaintext = plaintext.replaceRange(i, i + 1, plaintext[i].toUpperCase());
      } else {
        plaintext = plaintext.replaceRange(i, i + 1, plaintext[i].toLowerCase());
      }
    }
    return plaintext;
  }

  static void isUPP(String plainText, List<bool> isUp) {
    for (int i = 0; i < plainText.length; i++) {
      if (plainText[i].toUpperCase() == plainText[i]) {
        isUp.add(true);
      } else {
        isUp.add(false);
      }
    }
  }

  bool _isAlpha(String c) {
    return (c.toUpperCase() != c.toLowerCase()); // Check if the character is alphabetic
  }
}
