import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/vocab_word.dart';
import '../../services/content_service.dart';
import '../../theme/app_theme.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryCard {
  _MemoryCard({
    required this.word,
    required this.isGerman,
    required this.keyId,
  });

  final VocabWord word;
  final bool isGerman;
  final String keyId;
  bool faceUp = false;
  bool matched = false;

  String get label => isGerman ? word.de : word.ar;
}

class _MemoryGameState extends State<MemoryGame> {
  final _random = Random();
  List<_MemoryCard> _cards = [];
  int? _firstIndex;
  bool _busy = false;
  int _moves = 0;
  int _matches = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final words = await ContentService.instance.loadWords();
    words.shuffle(_random);
    final selected = words.take(8).toList();
    final cards = <_MemoryCard>[];
    for (final w in selected) {
      cards.add(_MemoryCard(word: w, isGerman: true, keyId: 'de-${w.id}'));
      cards.add(_MemoryCard(word: w, isGerman: false, keyId: 'ar-${w.id}'));
    }
    cards.shuffle(_random);
    setState(() {
      _cards = cards;
      _loading = false;
      _moves = 0;
      _matches = 0;
      _firstIndex = null;
    });
  }

  Future<void> _flip(int index) async {
    final card = _cards[index];
    if (_busy || card.faceUp || card.matched) return;

    setState(() => card.faceUp = true);

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    _busy = true;
    _moves++;
    final first = _cards[_firstIndex!];
    final second = card;

    if (first.word.id == second.word.id && first.isGerman != second.isGerman) {
      setState(() {
        first.matched = true;
        second.matched = true;
        _matches++;
        _firstIndex = null;
      });
      _busy = false;
      if (_matches == 8) _win();
    } else {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        first.faceUp = false;
        second.faceUp = false;
        _firstIndex = null;
      });
      _busy = false;
    }
  }

  void _win() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mémoire réussie !'),
        content: Text('Coups : $_moves'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '$_moves coups',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.78,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                final show = card.faceUp || card.matched;
                return GestureDetector(
                  onTap: () => _flip(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    decoration: BoxDecoration(
                      color: card.matched
                          ? const Color(0xFF45B36B)
                          : show
                              ? Colors.white
                              : AppTheme.forest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.gold.withValues(alpha: 0.4),
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(6),
                    child: show
                        ? Text(
                            card.label,
                            textAlign: TextAlign.center,
                            textDirection: card.isGerman
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: card.isGerman ? 13 : 15,
                              color: card.matched ? Colors.white : AppTheme.ink,
                            ),
                          )
                        : Text(
                            card.word.image,
                            style: const TextStyle(fontSize: 26),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
