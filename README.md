# Flutter Furigana Text

[![pub version](https://img.shields.io/pub/v/flutter_furigana_text.svg)](https://pub.dev/packages/flutter_furigana_text)

A Flutter widget to render Japanese text with Furigana (ruby characters), supporting custom styling, smart line wrapping, and tap events. Ideal for Japanese learning apps, readers, and dictionaries.

## ✨ Features

* **Smart Wrapping**: Automatically wraps text to the next line without breaking a word and its furigana.
* **Tap Events**: Detects taps on individual words/characters.
* **Custom Styling**: Easily customize the style for both main text and furigana.
* **Highlighting**: Built-in support for highlighting specific words.
* **Bracket Parser**: Parse strings in the format `漢字[かんじ]` into a list of FuriganaWord/FuriganaChar.

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_furigana_text: ^0.0.1
```

Then, run `flutter pub get` in your terminal.

## 💻 Usage

Import the package:
```dart
import 'package:flutter_furigana_text/flutter_furigana_text.dart';
```

Create a list of `FuriganaChar` and pass it to the `FuriganaText` widget.

```dart
// Data
final sentence = [
  FuriganaChar(text: '私', furigana: 'わたし', meaning: 'I'),
  FuriganaChar(text: 'は'),
  FuriganaChar(text: '日本語', furigana: 'にほんご', meaning: 'Japanese'),
];

// Widget
FuriganaText(
  spans: sentence,
  onSpanTap: (index) {
    setState(() {
      // Handle tap on the word at `index`
      print('Tapped on: ${sentence[index].text}');
    });
  },
)
```

```dart
// Parse from bracketed string
final input = '漢字[かんじ]を勉強[べんきょう]します。';
final parsed = FuriganaParser.parseFromBrackets(input);
// `parsed` will be a List<FuriganaWord> with corresponding text and furigana
```