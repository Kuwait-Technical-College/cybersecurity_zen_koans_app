import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import 'koan_model.dart';

class KoansRepository {
  late final List<KoanWithExplanation> koansWithExplanations;
  late final Map<String, KoanWithExplanation> _koansByCode;
  final _random = Random();

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/koans.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    koansWithExplanations = jsonList
        .map((e) => KoanWithExplanation.fromJson(e as Map<String, dynamic>))
        .toList();
    _koansByCode = {
      for (final k in koansWithExplanations) k.uniqueCode: k,
    };
  }

  KoanWithExplanation getRandomKoan() {
    return koansWithExplanations[_random.nextInt(koansWithExplanations.length)];
  }

  KoanWithExplanation? getKoanByCode(String code) {
    return _koansByCode[code];
  }
}
