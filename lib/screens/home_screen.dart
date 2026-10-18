import 'package:flutter/material.dart';

import '../models/cefr_level.dart';
import '../theme/app_theme.dart';
import '../widgets/level_card.dart';
import 'a1/a1_screen.dart';
import 'a2/a2_screen.dart';
import 'b1/b1_screen.dart';
import 'b2/b2_screen.dart';
import 'c1/c1_screen.dart';
import 'c2/c2_screen.dart';
import 'games/balloon_game.dart';
import 'games/crossword_game.dart';
import 'games/image_guess_game.dart';
import 'games/memory_game.dart';
import 'games/quiz_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _openLevel(BuildContext context, CefrLevel level) {
    final Widget page = switch (level) {
      CefrLevel.a1 => const A1Screen(),
      CefrLevel.a2 => const A2Screen(),
      CefrLevel.b1 => const B1Screen(),
      CefrLevel.b2 => const B2Screen(),
      CefrLevel.c1 => const C1Screen(),
      CefrLevel.c2 => const C2Screen(),
    };
    _open(context, page);
  }

  @override
  Widget build(BuildContext context) {
    const games = <_GameEntry>[
      _GameEntry(
        title: 'Balloon Pop',
        subtitle: 'Jeu principal · TTS',
        emoji: '🎈',
        color: Color(0xFFE85D4C),
        page: BalloonGame(),
        featured: true,
      ),
      _GameEntry(
        title: 'Quiz',
        subtitle: 'DE → AR',
        emoji: '❓',
        color: Color(0xFF1F4E79),
        page: QuizGame(),
      ),
      _GameEntry(
        title: 'Crossword',
        subtitle: 'Devine le mot',
        emoji: '🧩',
        color: Color(0xFF5C3D2E),
        page: CrosswordGame(),
      ),
      _GameEntry(
        title: 'Image Guess',
        subtitle: 'Image → allemand',
        emoji: '🖼️',
        color: Color(0xFF2F6B4F),
        page: ImageGuessGame(),
      ),
      _GameEntry(
        title: 'Memory',
        subtitle: 'Associe DE / AR',
        emoji: '🃏',
        color: Color(0xFF9A7B3C),
        page: MemoryGame(),
      ),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEF3EF),
              Color(0xFFF5F1E8),
              Color(0xFFE8EEE9),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AUREA',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppTheme.forest,
                              height: 0.95,
                            ),
                      ),
                      Text(
                        'Deutsch',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppTheme.goldDeep,
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: 56,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppTheme.gold,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Apprenez l’allemand du A1 au C2 — vocabulaire, '
                        'verbes et jeux interactifs.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Jeux',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      for (final game in games)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _GameTile(
                            entry: game,
                            onTap: () => _open(context, game.page),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Text(
                    'Niveaux CECR',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.92,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final level = CefrLevel.values[index];
                      return LevelCard(
                        level: level,
                        onTap: () => _openLevel(context, level),
                      );
                    },
                    childCount: CefrLevel.values.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameEntry {
  const _GameEntry({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.page,
    this.featured = false,
  });

  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final Widget page;
  final bool featured;
}

class _GameTile extends StatelessWidget {
  const _GameTile({required this.entry, required this.onTap});

  final _GameEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                entry.color,
                Color.lerp(entry.color, Colors.black, 0.25)!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: entry.color.withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: entry.featured ? 20 : 16,
            ),
            child: Row(
              children: [
                Text(entry.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (entry.featured) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppTheme.gold.withValues(alpha: 0.7),
                                ),
                              ),
                              child: const Text(
                                'MAIN',
                                style: TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        entry.subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_arrow_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
