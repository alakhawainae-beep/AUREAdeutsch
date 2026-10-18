import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/vocab_word.dart';
import '../../services/content_service.dart';
import '../../theme/app_theme.dart';

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({super.key});

  @override
  State<CrosswordGame> createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  final _random = Random();
  final _controller = TextEditingController();
  List<VocabWord> _clues = [];
  VocabWord? _current;
  int _solved = 0;
  int _score = 0;
  bool _loading = true;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final words = await ContentService.instance.loadWords();
    final filtered = words
        .where((w) => RegExp(r'^[A-Za-zÄÖÜäöüß]+$').hasMatch(w.de) && w.de.length <= 10)
        .toList()
      ..shuffle(_random);
    setState(() {
      _clues = filtered.take(8).toList();
      _current = _clues.isEmpty ? null : _clues.first;
      _loading = false;
      _solved = 0;
      _score = 0;
      _feedback = null;
    });
    _controller.clear();
  }

  void _check() {
    if (_current == null) return;
    final guess = _controller.text.trim().toLowerCase();
    final answer = _current!.de.toLowerCase();
    if (guess == answer) {
      setState(() {
        _solved++;
        _score += 15;
        _feedback = '✓ ${_current!.de} = ${_current!.ar}';
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        if (_solved >= _clues.length) {
          _finish();
        } else {
          setState(() {
            _current = _clues[_solved];
            _feedback = null;
          });
          _controller.clear();
        }
      });
    } else {
      setState(() => _feedback = 'Essaie encore…');
    }
  }

  void _finish() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mots croisés terminés'),
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
              _boot();
            },
            child: const Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  String _masked(String word) {
    if (word.isEmpty) return '';
    final chars = word.split('');
    return chars.asMap().entries.map((e) {
      if (e.key == 0 || e.key == chars.length - 1) return e.value;
      return '_';
    }).join(' ');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = _current;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '$_solved/${_clues.length}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: _loading || word == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Indice arabe',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppTheme.forest,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(word.image, style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(
                        word.ar,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Article : ${word.article}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Mot allemand',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    _masked(word.de),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 28,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Écris le mot allemand',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onSubmitted: (_) => _check(),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _check,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.forest,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Valider'),
                ),
                if (_feedback != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _feedback!,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _feedback!.startsWith('✓')
                          ? const Color(0xFF45B36B)
                          : const Color(0xFFE85D4C),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Liste des indices',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ..._clues.asMap().entries.map((e) {
                  final done = e.key < _solved;
                  return ListTile(
                    leading: Text(e.value.image),
                    title: Text(
                      e.value.ar,
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: Icon(
                      done ? Icons.check_circle : Icons.circle_outlined,
                      color: done
                          ? const Color(0xFF45B36B)
                          : AppTheme.ink.withValues(alpha: 0.3),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
