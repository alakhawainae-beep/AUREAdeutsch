import 'package:flutter/material.dart';

import '../../models/cefr_level.dart';
import '../level_workspace_screen.dart';

/// C1 advanced level entry point.
class C1Screen extends StatelessWidget {
  const C1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelWorkspaceScreen(
      level: CefrLevel.c1,
      lessons: [
        'Akademische Texte',
        'Idiomatische Wendungen',
        'Präzise Ausdrucksweise',
        'Komplexe Strukturen',
      ],
    );
  }
}
