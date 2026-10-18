class VocabWord {
  const VocabWord({
    required this.id,
    required this.de,
    required this.ar,
    required this.article,
    required this.image,
    required this.imagePath,
    required this.category,
  });

  final int id;
  final String de;
  final String ar;
  final String article;
  final String image;
  final String imagePath;
  final String category;

  String get displayDe =>
      article == '—' || article.isEmpty ? de : '$article $de';

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      id: json['id'] as int,
      de: json['de'] as String,
      ar: json['ar'] as String,
      article: json['article'] as String? ?? '—',
      image: json['image'] as String? ?? '🔤',
      imagePath: json['imagePath'] as String? ?? '',
      category: json['category'] as String? ?? 'basics',
    );
  }
}
