class KeyLessTransPosition {
  List<String> toWords(String text) {
    List<String> words = [];
    String currentWord = '';
    
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ' ') {
        if (currentWord.isNotEmpty) {
          words.add(currentWord);
          currentWord = '';
        }
      } else {
        currentWord += text[i];
      }
    }
    
    if (currentWord.isNotEmpty) {
      words.add(currentWord);
    }
    
    return words;
  }

  List<String> createMatrix(String text) {
    String cleanText = '';
    
    // Preserve only alphanumeric characters
    for (int i = 0; i < text.length; i++) {
      if (_isAlphaNumeric(text[i])) {
        cleanText += text[i].toUpperCase();
      }
    }
    
    // Pad with 'X' to make length divisible by 4
    while (cleanText.length % 4 != 0) {
      cleanText += 'X';
    }
    
    // Split into blocks of 4
    List<String> blocks = [];
    for (int i = 0; i < cleanText.length; i += 4) {
      blocks.add(cleanText.substring(i, i + 4));
    }
    
    return blocks;
  }

  String encrypt(String plaintext) {
    List<String> matrix = createMatrix(plaintext);
    StringBuffer cipher = StringBuffer();
    
    // Read by columns
    for (int col = 0; col < 4; col++) {
      for (int row = 0; row < matrix.length; row++) {
        cipher.write(matrix[row][col]);
      }
    }
    
    return cipher.toString();
  }

  String decrypt(String ciphertext) {
    if (ciphertext.length % 4 != 0) {
      throw ArgumentError('Invalid ciphertext length');
    }

    int numBlocks = ciphertext.length ~/ 4;
    List<List<String>> grid = List.generate(
      numBlocks,
      (_) => List.filled(4, ''),
      growable: false
    );

    // Fill grid column by column
    int idx = 0;
    for (int col = 0; col < 4; col++) {
      for (int row = 0; row < numBlocks; row++) {
        grid[row][col] = ciphertext[idx++];
      }
    }

    // Read grid row by row
    StringBuffer decrypted = StringBuffer();
    for (var row in grid) {
      decrypted.writeAll(row);
    }

    String result = decrypted.toString();
    // Remove padding X's only from the end
    while (result.endsWith('X')) {
      result = result.substring(0, result.length - 1);
    }
    
    return result;
  }

  void checkSpaces(String plaintext, List<int> s) {
    List<String> words = toWords(plaintext);
    for (String word in words) {
      s.add(word.length);
    }
  }

  String originalText(String text, List<int> s, List<bool> isUp) {
    if (text.isEmpty || s.isEmpty) return '';

    StringBuffer result = StringBuffer();
    int currentPos = 0;

    // Split into words using the original word lengths
    for (int i = 0; i < s.length; i++) {
      if (currentPos + s[i] <= text.length) {
        String word = text.substring(currentPos, currentPos + s[i]);
        
        // Add the word
        result.write(word);
        
        // Add space after word if it's not the last word
        if (i < s.length - 1) {
          result.write(' ');
        }
        
        currentPos += s[i];
      }
    }

    // Restore original case
    String finalResult = result.toString();
    StringBuffer casedText = StringBuffer();
    
    for (int i = 0; i < finalResult.length; i++) {
      if (i < isUp.length) {
        casedText.write(isUp[i] ? 
          finalResult[i].toUpperCase() : 
          finalResult[i].toLowerCase()
        );
      } else {
        casedText.write(finalResult[i]);
      }
    }

    return casedText.toString();
  }

  static void isUPP(String plainText, List<bool> isUp) {
    isUp.clear();
    for (int i = 0; i < plainText.length; i++) {
      String char = plainText[i];
      if (char == ' ') {
        isUp.add(false);
      } else {
        isUp.add(char == char.toUpperCase() &&
                 char.toUpperCase() != char.toLowerCase());
      }
    }
  }

  bool _isAlphaNumeric(String c) {
    return RegExp(r'^[a-zA-Z0-9]$').hasMatch(c);
  }
}
