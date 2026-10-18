import 'package:flutter/material.dart';

import '../../models/cefr_level.dart';
import '../level_workspace_screen.dart';

/// A1 beginner level entry point.
class A1Screen extends StatelessWidget {
  const A1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelWorkspaceScreen(
      level: CefrLevel.a1,
      lessons: [
        'Hallo & Begrüßungen',
        'Sich vorstellen',
        'Zahlen und Farben',
        'Familie und Freunde',
      ],
    );
  }
}
