class Multiplicative {
  int modInverse(int a, {int m = 26}) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    return -1;  // No modular inverse found
  }

  String encrypt(String plaintext, int key) {
    String ciphertext = "";

    for (int i = 0; i < plaintext.length; i++) {
      String c = plaintext[i];
      if (_isAlpha(c)) {
        c = c.toUpperCase();
        int num = c.codeUnitAt(0) - 'A'.codeUnitAt(0);
        num = (key * num) % 26;
        ciphertext += String.fromCharCode(num + 'A'.codeUnitAt(0));
      } else {
        ciphertext += c;
      }
    }
    return ciphertext;
  }

  String decrypt(String ciphertext, int key, List<bool> isUp) {
    String plaintext = "";
    int modInverseKey = modInverse(key);

    if (modInverseKey == -1) {
      return "No modular inverse exists!";
    }

    for (int i = 0; i < ciphertext.length; i++) {
      String c = ciphertext[i];
      if (_isAlpha(c)) {
        c = c.toUpperCase();
        int num = c.codeUnitAt(0) - 'A'.codeUnitAt(0);
        num = (modInverseKey * num) % 26;
        plaintext += String.fromCharCode(num + 'A'.codeUnitAt(0));
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
