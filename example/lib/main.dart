import 'package:flutter/material.dart';
import 'package:flutter_furigana_text/flutter_furigana_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuriganaText Example',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<FuriganaChar> _sentence;
  String _selectedMeaning = 'Tap on a word to see its meaning.';

  @override
  void initState() {
    super.initState();
    _sentence = [
      FuriganaChar(text: '私', furigana: 'わたし', data: 'I'),
      FuriganaChar(text: 'は'),
      FuriganaChar(text: '日本語', furigana: 'にほんご', data: 'Japanese'),
      FuriganaChar(text: 'を'),
      FuriganaChar(text: '勉強', furigana: 'べんきょう', data: 'Study'),
      FuriganaChar(text: 'します。'),
      FuriganaChar(text: 'あなた', data: 'You'),
      FuriganaChar(text: 'も'),
      FuriganaChar(text: '一緒', furigana: 'いっしょ', data: 'Together'),
      FuriganaChar(text: 'に'),
      FuriganaChar(
        text: '頑張りましょう',
        furigana: 'がんばりましょう',
        data: 'Let\'s try our best',
      ),
      FuriganaChar(text: '！'),
    ];
  }

  void _handleTap(int index) {
    setState(() {
      for (int i = 0; i < _sentence.length; i++) {
        _sentence[i].isHighlighted = (i == index);
      }
      _selectedMeaning =
          _sentence[index].data as String? ?? '(No meaning available)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FuriganaText Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tap on the Japanese text below:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FuriganaText(spans: _sentence, onSpanTap: _handleTap),
            ),
            const SizedBox(height: 40),
            // Demo parser FuriganaParser
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Parser demo (FuriganaParser.parseFromBrackets) and (FuriganaHtmlParser.parse)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final input = '漢字[かんじ]を勉強[べんきょう]します。';
                      final inputHtml = '今日は<ruby>漢字<rt>かんじ</rt></ruby>を勉強します。';
                      final parsed = FuriganaParser.parseFromBrackets(input);
                      final parsedHtml = FuriganaHtmlParser.parse(inputHtml);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Input:  $input'),
                          const SizedBox(height: 4),
                          ...parsed.map(
                            (w) => Text(
                              'text: "${w.text}"${w.furigana != null ? ', furigana: "${w.furigana}"' : ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Input:  $inputHtml'),
                          const SizedBox(height: 4),
                          ...parsedHtml.map(
                            (w) => Text(
                              'text: "${w.text}"${w.furigana != null ? ', furigana: "${w.furigana}"' : ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(
                  red: 63,
                  green: 81,
                  blue: 181,
                  alpha: 25,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _selectedMeaning,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.indigo[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
