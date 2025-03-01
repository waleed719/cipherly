class KeyedTransPosition {
  static const List<List<int>> key = [
    [3, 1, 4, 5, 2],
    [1, 2, 3, 4, 5]
  ];

  List<String> toWords(String text) {
    List<String> words = [];
    StringBuffer currentWord = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ' ') {
        if (currentWord.isNotEmpty) {
          words.add(currentWord.toString());
          currentWord.clear();
        }
      } else {
        currentWord.write(text[i]);
      }
    }
    
    if (currentWord.isNotEmpty) {
      words.add(currentWord.toString());
    }
    
    return words;
  }

  List<String> createMatrix(String text) {
    StringBuffer cleanText = StringBuffer();
    
    // Clean the text to only include alphanumeric characters
    for (int i = 0; i < text.length; i++) {
      if (_isAlphaNumeric(text[i])) {
        cleanText.write(text[i].toUpperCase());
      }
    }
    
    // Pad with 'X' to make length divisible by 5
    while (cleanText.length % 5 != 0) {
      cleanText.write('X');
    }
    
    // Split into blocks of 5 characters
    List<String> blocks = [];
    String processedText = cleanText.toString();
    for (int i = 0; i < processedText.length; i += 5) {
      blocks.add(processedText.substring(i, i + 5));
    }
    
    return blocks;
  }

  String encrypt(String plaintext) {
    List<String> matrix = createMatrix(plaintext);
    StringBuffer cipher = StringBuffer();
    
    for (String block in matrix) {
      List<String> chars = List.filled(5, '');
      // Apply the key transformation
      for (int j = 0; j < block.length; j++) {
        int k = key[0][j] - 1; // Convert 1-based index to 0-based
        chars[j] = block[k];
      }
      cipher.writeAll(chars);
    }
    
    return cipher.toString();
  }

  String decrypt(String text) {
    List<String> matrix = createMatrix(text);
    StringBuffer cipher = StringBuffer();
    
    for (String block in matrix) {
      List<String> decrypted = List.filled(5, '');
      // Reverse the key transformation
      for (int j = 0; j < block.length; j++) {
        int k = key[0][j] - 1; // Convert 1-based index to 0-based
        decrypted[k] = block[j];
      }
      cipher.writeAll(decrypted);
    }
    
    String result = cipher.toString();
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
    
    // Reconstruct words with proper lengths
    for (int i = 0; i < s.length; i++) {
      if (currentPos + s[i] <= text.length) {
        // Extract the word
        String word = text.substring(currentPos, currentPos + s[i]);
        result.write(word);
        
        // Add space if not the last word
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
    isUp.clear(); // Clear any existing values
    for (int i = 0; i < plainText.length; i++) {
      if (plainText[i] == ' ') {
        isUp.add(false);
      } else {
        isUp.add(plainText[i] == plainText[i].toUpperCase() &&
                 plainText[i].toUpperCase() != plainText[i].toLowerCase());
      }
    }
  }

  bool _isAlphaNumeric(String c) {
    return RegExp(r'^[a-zA-Z0-9]$').hasMatch(c);
  }
}