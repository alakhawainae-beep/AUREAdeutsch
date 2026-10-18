import 'package:flutter/material.dart';

import '../../models/cefr_level.dart';
import '../level_workspace_screen.dart';

/// B2 upper-intermediate level entry point.
class B2Screen extends StatelessWidget {
  const B2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LevelWorkspaceScreen(
      level: CefrLevel.b2,
      lessons: [
        'Argumentation und Debatte',
        'Medien und Gesellschaft',
        'Formelle Kommunikation',
        'Nuancen und Stil',
      ],
    );
  }
}
