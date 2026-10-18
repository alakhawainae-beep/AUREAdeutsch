class VerbConjugation {
  const VerbConjugation({
    required this.ich,
    required this.du,
    required this.erSieEs,
    required this.wir,
    required this.ihr,
    required this.sieSie,
    this.hilfsverb,
    this.partizip,
  });

  final String ich;
  final String du;
  final String erSieEs;
  final String wir;
  final String ihr;
  final String sieSie;
  final String? hilfsverb;
  final String? partizip;

  factory VerbConjugation.fromJson(Map<String, dynamic> json) {
    return VerbConjugation(
      ich: json['ich'] as String,
      du: json['du'] as String,
      erSieEs: json['er_sie_es'] as String,
      wir: json['wir'] as String,
      ihr: json['ihr'] as String,
      sieSie: json['sie_Sie'] as String,
      hilfsverb: json['hilfsverb'] as String?,
      partizip: json['partizip'] as String?,
    );
  }

  Map<String, String> get asMap => {
        'ich': ich,
        'du': du,
        'er/sie/es': erSieEs,
        'wir': wir,
        'ihr': ihr,
        'sie/Sie': sieSie,
      };
}

class Verb {
  const Verb({
    required this.id,
    required this.infinitive,
    required this.ar,
    required this.praesens,
    required this.praeteritum,
    required this.perfekt,
    required this.futur,
  });

  final int id;
  final String infinitive;
  final String ar;
  final VerbConjugation praesens;
  final VerbConjugation praeteritum;
  final VerbConjugation perfekt;
  final VerbConjugation futur;

  factory Verb.fromJson(Map<String, dynamic> json) {
    return Verb(
      id: json['id'] as int,
      infinitive: json['infinitive'] as String,
      ar: json['ar'] as String,
      praesens: VerbConjugation.fromJson(
        json['praesens'] as Map<String, dynamic>,
      ),
      praeteritum: VerbConjugation.fromJson(
        json['praeteritum'] as Map<String, dynamic>,
      ),
      perfekt: VerbConjugation.fromJson(
        json['perfekt'] as Map<String, dynamic>,
      ),
      futur: VerbConjugation.fromJson(json['futur'] as Map<String, dynamic>),
    );
  }
}
