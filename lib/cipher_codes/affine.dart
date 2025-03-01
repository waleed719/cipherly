class Affine {
  int isInverse(int a, {int m = 26}) {
    a = a % m;
    for (int i = 1; i < m; i++) {
      if ((a * i) % m == 1) {
        return 1;
      }
    }
    return -1;
  }

  int findInverse(int a, {int m = 26}) {
    a = a % m;
    for (int i = 0; i < m; i++) {
      if ((a * i) % m == 1) {
        return i;
      }
    }
    return -1; // Should not reach here if the inverse exists
  }

  String encrypt(String plainText, int key1, int key2) {
    // Formula: C = ((P * K1) + K2) mod 26
    String cipherText = "";

    if (isInverse(key1) == -1) {
      return "Key must have multiplicative inverse";
    }

    for (int i = 0; i < plainText.length; i++) {
      String c = plainText[i];
      if (_isAlpha(c)) {
        c = c.toUpperCase();
        int num = c.codeUnitAt(0) - 'A'.codeUnitAt(0);
        num = ((num * key1) + key2) % 26;
        cipherText += String.fromCharCode(num + 'A'.codeUnitAt(0));
      } else {
        cipherText += c;
      }
    }

    return cipherText;
  }

  String decrypt(String cipherText, int key1, int key2, List<bool> isUp) {
    // Formula: P = ((C - K2) * K1_inverse) mod 26
    String plaintext = "";
    int k1Inverse = findInverse(key1);

    for (int i = 0; i < cipherText.length; i++) {
      String c = cipherText[i];
      if (_isAlpha(c)) {
        int num = c.codeUnitAt(0) - 'A'.codeUnitAt(0);
        num = ((num - key2) * k1Inverse) % 26;
        if (num < 0) {
          num += 26;
        }
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
