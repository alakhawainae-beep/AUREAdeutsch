import 'package:flutter/material.dart';

/// CEFR language proficiency levels supported by AUREA Deutsch.
enum CefrLevel {
  a1(
    code: 'A1',
    title: 'Débutant',
    subtitle: 'Bases essentielles',
    description:
        'Saluer, se présenter et comprendre des phrases très simples du quotidien.',
    color: Color(0xFF2F6B4F),
  ),
  a2(
    code: 'A2',
    title: 'Élémentaire',
    subtitle: 'Vie quotidienne',
    description:
        'Exprimer des besoins concrets et échanger sur des sujets familiers.',
    color: Color(0xFF3D7A5F),
  ),
  b1(
    code: 'B1',
    title: 'Intermédiaire',
    subtitle: 'Autonomie',
    description:
        'Gérer la plupart des situations en voyage et parler d’expériences personnelles.',
    color: Color(0xFF1F4E79),
  ),
  b2(
    code: 'B2',
    title: 'Avancé',
    subtitle: 'Aisance',
    description:
        'Comprendre des textes complexes et argumenter avec clarté et nuance.',
    color: Color(0xFF163A5F),
  ),
  c1(
    code: 'C1',
    title: 'Autonome',
    subtitle: 'Maîtrise',
    description:
        'S’exprimer spontanément, avec précision, sur des sujets exigeants.',
    color: Color(0xFF5C3D2E),
  ),
  c2(
    code: 'C2',
    title: 'Maîtrise',
    subtitle: 'Excellence',
    description:
        'Comprendre presque tout et s’exprimer avec la finesse d’un locuteur natif.',
    color: Color(0xFF3A2A22),
  );

  const CefrLevel({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });

  final String code;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
}
