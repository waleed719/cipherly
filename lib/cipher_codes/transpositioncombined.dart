class CombinedTransPosition {
  final List<List<int>> key = [
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
        currentWord.write(text[i].toUpperCase());
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
    List<String> cipherwords = [];

    // Apply the column-wise transformation based on the key
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < matrix.length; j++) {
        cipher.write(matrix[j][i]);
      }
      cipherwords.add(cipher.toString());
      cipher.clear(); // Reset cipher after each column
    }

    // Use key to rearrange the columns
    List<String> cipherV = List.filled(cipherwords.length, " ");
    for (int i = 0; i < cipherwords.length; i++) {
      int k = key[0][i] - 1;  // Adjust for 1-based index of key
      cipherV[i] = cipherwords[k];
    }

    return cipherV.join();
  }

  String decrypt(String ciphertext) {
    int numCols = 5;
    int numRows = ciphertext.length ~/ numCols;

    // Initialize a grid based on the number of rows and columns
    List<List<String>> grid = List.generate(
      numRows, 
      (_) => List.filled(numCols, ' ')
    );

    int idx = 0;
    for (int i = 0; i < numCols; i++) {
      int colIndex = key[0][i] - 1; // Adjust for 1-based index of key
      for (int j = 0; j < numRows; j++) {
        grid[j][colIndex] = ciphertext[idx++];
      }
    }

    String plaintext = "";
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        plaintext += grid[i][j];
      }
    }

    // Remove any padding (X) at the end
    int pos = plaintext.indexOf('X');
    if (pos != -1) {
      plaintext = plaintext.substring(0, pos);
    }

    return plaintext;
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
        casedText.write(isUp[i] 
            ? finalResult[i].toUpperCase() 
            : finalResult[i].toLowerCase());
      } else {
        casedText.write(finalResult[i]);
      }
    }

    return casedText.toString();
  }

  static void isUPP(String plainText, List<bool> isUp) {
    isUp.clear();
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