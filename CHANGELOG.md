## 0.0.1

* Initial stable release.
* Support for smart line wrapping, custom styles, and tap events.

## 0.0.2

* Added FuriganaParser: Support for parsing strings in the format `漢字[かんじ]` into a list of FuriganaWord/FuriganaChar.

## 0.0.3

* Added FuriganaHtmlParser: Support for parsing HTML strings with <ruby> and <rt> tags (e.g. `今日は<ruby>漢字<rt>かんじ</rt></ruby>を勉強します。`) into a list of FuriganaWord/FuriganaChar. 

## 0.0.4

* Added furigana-aware search & highlight: Search and highlight spans by Kanji, Hiragana, or Furigana (matches both main text and furigana). 