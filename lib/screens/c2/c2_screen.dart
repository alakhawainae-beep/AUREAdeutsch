import 'package:flutter/material.dart';

import '../../models/cefr_level.dart';
import '../level_workspace_screen.dart';

/// C2 mastery level entry point.
class C2Screen extends StatelessWidget {
  const C2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelWorkspaceScreen(
      level: CefrLevel.c2,
      lessons: [
        'Literarische Sprache',
        'Rhetorik und Stilistik',
        'Kulturelle Feinheiten',
        'Muttersprachliches Niveau',
      ],
    );
  }
}
