import 'package:flutter/material.dart';

import '../../models/cefr_level.dart';
import '../level_workspace_screen.dart';

/// A2 elementary level entry point.
class A2Screen extends StatelessWidget {
  const A2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelWorkspaceScreen(
      level: CefrLevel.a2,
      lessons: [
        'Alltag und Routinen',
        'Einkaufen gehen',
        'Unterwegs in der Stadt',
        'Freizeit und Hobbys',
      ],
    );
  }
}
