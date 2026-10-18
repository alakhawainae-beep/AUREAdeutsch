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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openLevel(BuildContext context, CefrLevel level) {
    final Widget page = switch (level) {
      CefrLevel.a1 => const A1Screen(),
      CefrLevel.a2 => const A2Screen(),
      CefrLevel.b1 => const B1Screen(),
      CefrLevel.b2 => const B2Screen(),
      CefrLevel.c1 => const C1Screen(),
      CefrLevel.c2 => const C2Screen(),
    };

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

  @override
  Widget build(BuildContext context) {
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
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 16 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AUREA',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: AppTheme.forest,
                                    height: 0.95,
                                  ),
                            ),
                            Text(
                              'Deutsch',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
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
                              'Apprenez l’allemand du niveau A1 au C2, '
                              'avec un parcours clair et progressif.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Choisir un niveau',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 14),
                    ],
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
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 450 + (index * 80)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: LevelCard(
                          level: level,
                          onTap: () => _openLevel(context, level),
                        ),
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
