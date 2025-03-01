class AutoKey {
  String encrypt(String plaintext, String key) {
    String ciphertext = "";
    int keyIndex = 0;

    for (int i = 0; i < plaintext.length; i++) {
      String p = plaintext[i];

      if (isAlpha(p)) {
        p = p.toUpperCase();
        String k = key[keyIndex % key.length].toUpperCase();
        int pValue = p.codeUnitAt(0) - 'A'.codeUnitAt(0);
        int kValue = k.codeUnitAt(0) - 'A'.codeUnitAt(0);

        int cValue = (pValue + kValue) % 26;
        String c = String.fromCharCode(cValue + 'A'.codeUnitAt(0));
        ciphertext += c;

        key += p; // Append plaintext character to the key
        keyIndex++;
      } else {
        ciphertext += p;
      }
    }

    return ciphertext;
  }

  String decrypt(String text, String key, List<bool> isUp) {
    String plaintext = "";
    int keyIndex = 0;

    for (int i = 0; i < text.length; i++) {
      String c = text[i];

      if (isAlpha(c)) {
        c = c.toUpperCase();
        String k = key[keyIndex % key.length].toUpperCase();
        int cValue = c.codeUnitAt(0) - 'A'.codeUnitAt(0);
        int kValue = k.codeUnitAt(0) - 'A'.codeUnitAt(0);

        int pValue = (cValue - kValue + 26) % 26;
        String p = String.fromCharCode(pValue + 'A'.codeUnitAt(0));
        plaintext += p;

        key += p; // Append decrypted character to the key
        keyIndex++;
      } else {
        plaintext += c;
      }
    }

    // Revert the case of the decrypted text according to the original case
    for (int i = 0; i < plaintext.length; i++) {
      if (isUp[i]) {
        plaintext = plaintext.replaceRange(i, i + 1, plaintext[i].toUpperCase());
      } else {
        plaintext = plaintext.replaceRange(i, i + 1, plaintext[i].toLowerCase());
      }
    }

    return plaintext;
  }

  static void isUPP(String text, List<bool> isUp) {
    for (int i = 0; i < text.length; i++) {
      if (text[i].toUpperCase() == text[i]) {
        isUp.add(true);
      } else {
        isUp.add(false);
      }
    }
  }

  bool isAlpha(String c) {
    return (c.toUpperCase() != c.toLowerCase()); // Check if the character is alphabetic
  }
}
