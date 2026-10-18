import 'package:flutter/material.dart';

import '../../models/cefr_level.dart';
import '../level_workspace_screen.dart';

/// B1 intermediate level entry point.
class B1Screen extends StatelessWidget {
  const B1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelWorkspaceScreen(
      level: CefrLevel.b1,
      lessons: [
        'Reisen und Unterkunft',
        'Arbeit und Ausbildung',
        'Meinungen äußern',
        'Vergangenheit erzählen',
      ],
    );
  }
}
