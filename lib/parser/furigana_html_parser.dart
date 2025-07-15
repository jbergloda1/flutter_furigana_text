import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

import '../models/furigana_word.dart';

class FuriganaHtmlParser {
  static List<FuriganaWord> parse(String htmlString) {
    final document = html_parser.parseFragment(htmlString);
    final List<FuriganaWord> results = [];

    for (final node in document.nodes) {
      _parseNode(node, results);
    }

    return results;
  }

  static void _parseNode(dom.Node node, List<FuriganaWord> results) {
    if (node.nodeType == dom.Node.TEXT_NODE) {
      results.add(FuriganaWord(text: node.text ?? ""));
    } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
      final element = node as dom.Element;

      if (element.localName == 'ruby') {
        final rubyText = StringBuffer();
        String? rtText;

        for (final child in element.nodes) {
          if (child.nodeType == dom.Node.TEXT_NODE) {
            rubyText.write(child.text);
          } else if (child is dom.Element && child.localName == 'rt') {
            rtText = child.text;
          }
        }

        results.add(FuriganaWord(text: rubyText.toString(), furigana: rtText));
      } else {
        for (final child in element.nodes) {
          _parseNode(child, results);
        }
      }
    }
  }
}
