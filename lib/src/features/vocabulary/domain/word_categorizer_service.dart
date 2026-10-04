import 'package:flutter/material.dart';

/// Définition d'un domaine sémantique CECRL avec ses métadonnées visuelles
class SemanticDomain {
  final String id;
  final String labelFr;
  final String labelEn;
  final IconData icon;
  final Color accentColor;

  const SemanticDomain({
    required this.id,
    required this.labelFr,
    required this.labelEn,
    required this.icon,
    required this.accentColor,
  });
}

/// Service autonome de catégorisation sémantique (Zero Clé API).
/// Associe un mot ou une phrase à l'un des 9 domaines thématiques du CECRL.
class WordCategorizerService {
  const WordCategorizerService();

  static const List<SemanticDomain> domains = [
    SemanticDomain(
      id: 'Basics & Greetings',
      labelFr: 'Salutations & Présentation',
      labelEn: 'Basics & Greetings',
      icon: Icons.waving_hand,
      accentColor: Color(0xFFB5EAD7), // pastelMint
    ),
    SemanticDomain(
      id: 'Food & Drink',
      labelFr: 'Nourriture & Repas',
      labelEn: 'Food & Drink',
      icon: Icons.restaurant,
      accentColor: Color(0xFFFFDAC1), // pastelPeach
    ),
    SemanticDomain(
      id: 'Daily Life & Home',
      labelFr: 'Vie quotidienne & Maison',
      labelEn: 'Daily Life & Home',
      icon: Icons.home,
      accentColor: Color(0xFFC7CEEA), // pastelBlue
    ),
    SemanticDomain(
      id: 'Travel & Places',
      labelFr: 'Voyages & Lieux',
      labelEn: 'Travel & Places',
      icon: Icons.flight_takeoff,
      accentColor: Color(0xFFE2F0CB), // pastelLime
    ),
    SemanticDomain(
      id: 'Work & Tech',
      labelFr: 'Travail & Numérique',
      labelEn: 'Work & Tech',
      icon: Icons.computer,
      accentColor: Color(0xFFFFB7B2), // pastelCoral
    ),
    SemanticDomain(
      id: 'Social & Mind',
      labelFr: 'Relations & Esprit',
      labelEn: 'Social & Mind',
      icon: Icons.psychology,
      accentColor: Color(0xFFFFF1C5), // pastelYellow
    ),
    SemanticDomain(
      id: 'Nature & Animals',
      labelFr: 'Nature & Animaux',
      labelEn: 'Nature & Animals',
      icon: Icons.pets,
      accentColor: Color(0xFFD4F0F0), // pastelCyan
    ),
    SemanticDomain(
      id: 'Body & Health',
      labelFr: 'Corps & Santé',
      labelEn: 'Body & Health',
      icon: Icons.favorite,
      accentColor: Color(0xFFFF9AA2), // pastelRed
    ),
    SemanticDomain(
      id: 'Leisure & Culture',
      labelFr: 'Loisirs & Culture',
      labelEn: 'Leisure & Culture',
      icon: Icons.palette,
      accentColor: Color(0xFFE8D7FF), // pastelPurple
    ),
  ];

  static SemanticDomain getDomainById(String id) {
    // Normaliser pour supporter les variantes historiques de catégories
    final normalized = switch (id.toLowerCase().trim()) {
      'daily life' => 'Daily Life & Home',
      'daily life & travel' => 'Travel & Places',
      'social & abstract' => 'Social & Mind',
      _ => id,
    };

    return domains.firstWhere(
      (d) => d.id.toLowerCase() == normalized.toLowerCase() || d.id == id,
      orElse: () => domains[2], // Daily Life & Home par défaut
    );
  }

  // --- Dictionnaires thématiques pour l'inférence lexicale instantanée ---

  static const Map<String, List<String>> _domainKeywords = {
    'Basics & Greetings': [
      'hello', 'hi', 'welcome', 'name', 'please', 'thanks', 'thank', 'sorry',
      'excuse', 'goodbye', 'bye', 'meet', 'nice', 'friend', 'family', 'mr',
      'mrs', 'miss', 'yes', 'no', 'pardon', 'introduce', 'spell'
    ],
    'Food & Drink': [
      'water', 'bread', 'apple', 'coffee', 'tea', 'milk', 'beer', 'wine',
      'eat', 'drink', 'food', 'meal', 'breakfast', 'lunch', 'dinner', 'snack',
      'cook', 'kitchen', 'restaurant', 'fruit', 'vegetable', 'meat', 'fish',
      'chicken', 'cheese', 'sugar', 'salt', 'pepper', 'egg', 'rice', 'pasta',
      'soup', 'cake', 'sweet', 'delicious', 'taste', 'hungry', 'thirsty', 'bake',
      'menu', 'plate', 'fork', 'knife', 'spoon', 'glass', 'cup', 'bottle'
    ],
    'Daily Life & Home': [
      'house', 'home', 'room', 'bed', 'sleep', 'wake', 'clean', 'door',
      'window', 'chair', 'table', 'bath', 'shower', 'wash', 'cloth', 'shirt',
      'pants', 'dress', 'shoes', 'wear', 'clock', 'morning', 'evening', 'night',
      'day', 'today', 'tomorrow', 'yesterday', 'buy', 'shop', 'store', 'market',
      'routine', 'habit', 'money', 'price', 'cost', 'pay', 'open', 'close',
      'key', 'light', 'floor', 'wall', 'garden', 'neighbor', 'neighborhood'
    ],
    'Travel & Places': [
      'travel', 'trip', 'journey', 'station', 'airport', 'train', 'bus', 'car',
      'plane', 'airplane', 'flight', 'ticket', 'passport', 'luggage', 'baggage',
      'hotel', 'room', 'city', 'town', 'village', 'country', 'street', 'road',
      'map', 'direction', 'visit', 'tour', 'tourism', 'tourist', 'leave',
      'arrive', 'arrival', 'departure', 'drive', 'subway', 'metro', 'taxi',
      'abroad', 'foreign', 'destination', 'explore', 'booking', 'reservation'
    ],
    'Work & Tech': [
      'work', 'job', 'office', 'career', 'boss', 'manager', 'colleague',
      'computer', 'laptop', 'internet', 'web', 'software', 'app', 'email',
      'message', 'phone', 'call', 'meeting', 'project', 'deadline', 'task',
      'salary', 'business', 'company', 'industry', 'hire', 'contract',
      'interview', 'screen', 'keyboard', 'mouse', 'code', 'program', 'system',
      'data', 'file', 'tech', 'technology', 'engineer', 'developer'
    ],
    'Social & Mind': [
      'think', 'thought', 'know', 'knowledge', 'feel', 'feeling', 'believe',
      'belief', 'remember', 'forget', 'mind', 'idea', 'opinion', 'attitude',
      'emotion', 'love', 'hate', 'happy', 'sad', 'angry', 'afraid', 'fear',
      'hope', 'dream', 'culture', 'community', 'society', 'relation',
      'relationship', 'respect', 'trust', 'honest', 'truth', 'lie', 'secret',
      'freedom', 'peace', 'justice', 'reason', 'purpose', 'decision', 'choose'
    ],
    'Nature & Animals': [
      'animal', 'dog', 'cat', 'bird', 'horse', 'cow', 'pig', 'sheep', 'fish',
      'tree', 'plant', 'flower', 'grass', 'forest', 'wood', 'nature', 'sun',
      'moon', 'star', 'sky', 'rain', 'snow', 'wind', 'cloud', 'weather',
      'storm', 'sea', 'ocean', 'river', 'lake', 'mountain', 'hill', 'season',
      'spring', 'summer', 'autumn', 'fall', 'winter', 'wild', 'earth'
    ],
    'Body & Health': [
      'body', 'head', 'face', 'eye', 'ear', 'nose', 'mouth', 'tooth', 'teeth',
      'hair', 'hand', 'arm', 'leg', 'foot', 'feet', 'finger', 'heart', 'skin',
      'health', 'healthy', 'sick', 'ill', 'pain', 'hurt', 'doctor', 'nurse',
      'hospital', 'medicine', 'drug', 'clinic', 'dentist', 'exercise', 'fit',
      'tired', 'rest', 'blood', 'breathe', 'weight', 'diet'
    ],
    'Leisure & Culture': [
      'book', 'read', 'write', 'music', 'song', 'sing', 'dance', 'play',
      'game', 'sport', 'football', 'soccer', 'tennis', 'swim', 'run', 'walk',
      'movie', 'film', 'cinema', 'theater', 'art', 'paint', 'draw', 'picture',
      'photo', 'camera', 'hobby', 'guitar', 'piano', 'listen', 'watch', 'fun',
      'party', 'celebrate', 'festival', 'holiday', 'vacation'
    ],
  };

  /// Suggère la catégorie la plus probable pour un mot donné,
  /// en prenant optionnellement en compte la phrase d'exemple bilingue.
  String categorizeWord(String term, {String? contextSentence}) {
    final cleanTerm = term.trim().toLowerCase();

    // 1. Recherche par mot exact dans les dictionnaires
    for (final entry in _domainKeywords.entries) {
      if (entry.value.contains(cleanTerm)) {
        return entry.key;
      }
    }

    // 2. Recherche par racine ou sous-chaîne dans le terme
    for (final entry in _domainKeywords.entries) {
      for (final keyword in entry.value) {
        if (cleanTerm.startsWith(keyword) || keyword.startsWith(cleanTerm)) {
          if (cleanTerm.length >= 3 && keyword.length >= 3) {
            return entry.key;
          }
        }
      }
    }

    // 3. Analyse contextuelle : recherche de cooccurrences de mots-clés dans la phrase
    if (contextSentence != null && contextSentence.isNotEmpty) {
      final sentenceWords = contextSentence
          .toLowerCase()
          .replaceAll(RegExp(r"[^\w\s]"), ' ')
          .split(RegExp(r'\s+'));

      final scores = <String, int>{};
      for (final entry in _domainKeywords.entries) {
        int count = 0;
        for (final w in sentenceWords) {
          if (w != cleanTerm && entry.value.contains(w)) {
            count++;
          }
        }
        if (count > 0) scores[entry.key] = count;
      }

      if (scores.isNotEmpty) {
        final sorted = scores.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return sorted.first.key;
      }
    }

    // 4. Repli intelligent par défaut
    return 'Daily Life & Home';
  }
}
