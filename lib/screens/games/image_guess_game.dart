import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/vocab_word.dart';
import '../../services/content_service.dart';
import '../../services/tts_service.dart';
import '../../theme/app_theme.dart';

class ImageGuessGame extends StatefulWidget {
  const ImageGuessGame({super.key});

  @override
  State<ImageGuessGame> createState() => _ImageGuessGameState();
}

class _ImageGuessGameState extends State<ImageGuessGame> {
  final _random = Random();
  List<VocabWord> _pool = [];
  VocabWord? _target;
  List<VocabWord> _choices = [];
  int _score = 0;
  int _round = 0;
  bool _loading = true;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final words = await ContentService.instance.loadWords();
    setState(() {
      _pool = words;
      _loading = false;
    });
    _next();
  }

  void _next() {
    final shuffled = List<VocabWord>.of(_pool)..shuffle(_random);
    final target = shuffled.first;
    final choices = shuffled.take(4).toList()..shuffle(_random);
    setState(() {
      _target = target;
      _choices = choices;
      _answered = false;
      _round++;
    });
  }

  void _pick(VocabWord word) {
    if (_answered || _target == null) return;
    final ok = word.id == _target!.id;
    setState(() {
      _answered = true;
      if (ok) _score += 10;
    });
    if (ok) TtsService.instance.speakGerman(word.de);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        if (_round >= 15) {
          _finish();
        } else {
          _next();
        }
      }
    });
  }

  void _finish() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bravo !'),
        content: Text('Score : $_score'),
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
              setState(() {
                _score = 0;
                _round = 0;
              });
              _next();
            },
            child: const Text('Encore'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Guess'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '$_score',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forest,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _loading || _target == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Que vois-tu ?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _target!.ar,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 22,
                      color: AppTheme.goldDeep,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.forest.withValues(alpha: 0.1),
                            AppTheme.gold.withValues(alpha: 0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Text(
                        _target!.image,
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _choices.map((w) {
                      Color? color;
                      if (_answered) {
                        if (w.id == _target!.id) {
                          color = const Color(0xFF45B36B);
                        } else {
                          color = Colors.white;
                        }
                      }
                      return SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 50) / 2,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: color ?? AppTheme.forest,
                            foregroundColor:
                                color == Colors.white ? AppTheme.ink : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => _pick(w),
                          child: Text(
                            w.de,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
