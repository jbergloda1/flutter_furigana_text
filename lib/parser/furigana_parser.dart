import '../models/furigana_word.dart';

class FuriganaParser {
  static List<FuriganaWord> parseFromBrackets(String input) {
    final regex = RegExp(r'(.*?)\[(.*?)\]');
    final matches = regex.allMatches(input);
    final results = <FuriganaWord>[];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        results.add(FuriganaWord(text: input.substring(currentIndex, match.start)));
      }
      results.add(FuriganaWord(text: match.group(1)!, furigana: match.group(2)!));
      currentIndex = match.end;
    }
    if (currentIndex < input.length) {
      results.add(FuriganaWord(text: input.substring(currentIndex)));
    }
    return results;
  }
}