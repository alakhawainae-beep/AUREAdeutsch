import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/vocab_word.dart';
import '../../services/content_service.dart';
import '../../services/tts_service.dart';
import '../../theme/app_theme.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({super.key});

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  final _random = Random();
  List<VocabWord> _all = [];
  List<VocabWord> _words = [];
  VocabWord? _current;
  List<VocabWord> _options = [];
  int _index = 0;
  int _score = 0;
  bool _loading = true;
  int? _selectedId;
  bool _answered = false;

  static const _total = 12;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final words = await ContentService.instance.loadWords();
    final shuffled = List<VocabWord>.of(words)..shuffle(_random);
    setState(() {
      _all = words;
      _words = shuffled.take(_total).toList();
      _loading = false;
    });
    _nextQuestion(reset: true);
  }

  void _nextQuestion({bool reset = false}) {
    if (reset) {
      _index = 0;
      _score = 0;
    } else {
      _index++;
    }
    if (_index >= _words.length) {
      _showDone();
      return;
    }
    final current = _words[_index];
    final distractors = List<VocabWord>.of(
      (List<VocabWord>.of(_all)..shuffle(_random))
          .where((w) => w.id != current.id)
          .take(3),
    );
    final options = [...distractors, current]..shuffle(_random);
    setState(() {
      _current = current;
      _options = options;
      _selectedId = null;
      _answered = false;
    });
    TtsService.instance.speakGerman(current.de);
  }

  void _select(VocabWord option) {
    if (_answered || _current == null) return;
    final ok = option.id == _current!.id;
    setState(() {
      _selectedId = option.id;
      _answered = true;
      if (ok) _score++;
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) _nextQuestion();
    });
  }

  void _showDone() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz terminé'),
        content: Text('Score : $_score / ${_words.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Accueil'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _load();
            },
            child: const Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_score pts',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.forest,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _loading || _current == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${_index + 1} / ${_words.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.forest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _current!.image,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _current!.de,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              TtsService.instance.speakGerman(_current!.de),
                          icon: const Icon(Icons.volume_up, color: Colors.white),
                        ),
                        const Text(
                          'Quelle est la traduction arabe ?',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._options.map((opt) {
                    Color? bg;
                    if (_answered) {
                      if (opt.id == _current!.id) {
                        bg = const Color(0xFF45B36B);
                      } else if (opt.id == _selectedId) {
                        bg = const Color(0xFFE85D4C);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: bg ?? Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _select(opt),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppTheme.forest.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Text(
                              opt.ar,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: bg != null ? Colors.white : AppTheme.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
