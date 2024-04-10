String capitalize(String input) {
  List<String> words = input.split(' ');
  words = words.map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();
  return words.join(' ');
}