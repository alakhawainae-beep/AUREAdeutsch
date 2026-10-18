import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/verb.dart';
import '../models/vocab_word.dart';

class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  List<VocabWord>? _words;
  List<Verb>? _verbs;

  Future<List<VocabWord>> loadWords() async {
    if (_words != null) return _words!;
    final raw = await rootBundle.loadString('assets/data/words_a1.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _words = list
        .map((e) => VocabWord.fromJson(e as Map<String, dynamic>))
        .toList();
    return _words!;
  }

  Future<List<Verb>> loadVerbs() async {
    if (_verbs != null) return _verbs!;
    final raw = await rootBundle.loadString('assets/data/verbs.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _verbs = list.map((e) => Verb.fromJson(e as Map<String, dynamic>)).toList();
    return _verbs!;
  }
}
