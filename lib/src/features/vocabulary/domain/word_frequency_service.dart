import '../../settings/domain/cefr_level.dart';

/// Service de calcul de fréquence lexicale (Échelle de Zipf 1.0 - 7.0)
/// et déduction du niveau CECRL (A1, A2, B1, B2) 100% autonome et sans clé API.
class WordFrequencyService {
  const WordFrequencyService();

  /// Échelle de Zipf :
  /// Score >= 5.5 -> A1 (Mots vitaux / hyper-fréquents)
  /// Score 4.5 - 5.4 -> A2 (Mots quotidiens usuels)
  /// Score 3.5 - 4.4 -> B1 (Mots indépendants / intermédiaires)
  /// Score < 3.5 -> B2/C1 (Mots techniques / spécialisés)

  static final Map<String, double> _curatedEnglishZipf = {
    // A1 - Hyper-fréquents (Zipf >= 5.5)
    'be': 7.0, 'have': 6.8, 'do': 6.6, 'say': 6.3, 'go': 6.4, 'get': 6.3, 'make': 6.2,
    'know': 6.1, 'think': 6.0, 'take': 6.0, 'see': 6.0, 'come': 5.9, 'want': 5.8,
    'look': 5.8, 'use': 5.7, 'find': 5.7, 'give': 5.7, 'tell': 5.6, 'work': 5.6,
    'call': 5.5, 'try': 5.5, 'ask': 5.5, 'need': 5.5, 'feel': 5.5, 'eat': 5.6,
    'drink': 5.5, 'water': 5.8, 'food': 5.7, 'house': 5.7, 'home': 5.8, 'car': 5.6,
    'cat': 5.5, 'dog': 5.5, 'child': 5.8, 'family': 5.7, 'mother': 5.6, 'father': 5.6,
    'apple': 5.5, 'bread': 5.5, 'coffee': 5.6, 'tea': 5.5, 'milk': 5.5,
    'friend': 5.7, 'city': 5.6, 'book': 5.6, 'day': 6.0, 'night': 5.7, 'time': 6.1,
    'year': 5.9, 'good': 6.0, 'new': 5.9, 'first': 5.8, 'last': 5.7, 'long': 5.6,
    'great': 5.6, 'little': 5.6, 'own': 5.5, 'other': 5.7, 'old': 5.7, 'right': 5.8,
    'big': 5.7, 'small': 5.6, 'happy': 5.5, 'love': 5.7, 'live': 5.6, 'speak': 5.5,
    'read': 5.6, 'write': 5.5, 'learn': 5.5, 'play': 5.6, 'buy': 5.5, 'open': 5.5,
    'close': 5.5, 'help': 5.6, 'wait': 5.5, 'meet': 5.5, 'name': 5.7, 'sleep': 5.5,

    // A2 - Quotidiens usuels (Zipf 4.5 - 5.4)
    'travel': 4.9, 'trip': 4.8, 'journey': 4.6, 'station': 4.8, 'airport': 4.6,
    'train': 5.1, 'ticket': 4.7, 'hotel': 4.9, 'room': 5.3, 'weather': 4.9,
    'rain': 4.8, 'snow': 4.7, 'sun': 4.9, 'summer': 4.9, 'winter': 4.8,
    'kitchen': 4.7, 'cook': 4.8, 'restaurant': 4.9, 'menu': 4.5, 'breakfast': 4.6,
    'lunch': 4.7, 'dinner': 4.9, 'market': 5.0, 'shop': 5.1, 'store': 5.1,
    'clothes': 4.8, 'shoes': 4.7, 'wear': 5.0, 'doctor': 5.0, 'hospital': 4.9,
    'medicine': 4.5, 'pain': 4.9, 'body': 5.1, 'head': 5.2, 'hand': 5.4,
    'office': 5.1, 'computer': 4.8, 'internet': 4.8, 'phone': 5.1, 'message': 4.9,
    'email': 4.7, 'problem': 5.3, 'question': 5.2, 'idea': 5.3, 'decide': 4.8,
    'plan': 5.1, 'start': 5.3, 'finish': 4.8, 'remember': 5.1, 'forget': 4.8,
    'send': 5.1, 'receive': 4.8, 'spend': 5.0, 'cost': 5.0, 'cheap': 4.6,
    'expensive': 4.6, 'clean': 4.9, 'easy': 5.0, 'difficult': 4.8, 'early': 5.0,
    'late': 5.1, 'fast': 4.9, 'slow': 4.7, 'beautiful': 5.0, 'quiet': 4.8,
    'dangerous': 4.5, 'safe': 4.9, 'direction': 4.8, 'discount': 4.5,
    'emergency': 4.7, 'guidebook': 4.5, 'habit': 4.6, 'lifestyle': 4.7,
    'neighborhood': 4.7, 'passenger': 4.8, 'passport': 4.6, 'routine': 4.7,
    'schedule': 4.8, 'souvenir': 4.5, 'ticket': 4.8, 'tourism': 4.7,
    'vehicle': 4.8, 'attitude': 4.8, 'belief': 4.8, 'community': 5.0,
    'culture': 5.0, 'emotion': 4.8, 'freedom': 4.9, 'impression': 4.8,
    'knowledge': 5.0, 'opinion': 4.9, 'relation': 4.8, 'respect': 4.9,
    'society': 5.0, 'value': 5.1,

    // B1 - Autonomie (Zipf 3.5 - 4.4)
    'deadline': 3.9, 'brainstorm': 3.5, 'feedback': 4.3, 'commute': 3.8,
    'compromise': 4.0, 'mindset': 3.9, 'trust': 4.4, 'perspective': 4.3,
    'achievement': 4.2, 'analyze': 4.3, 'benefit': 4.4, 'challenge': 4.4,
    'growth': 4.4, 'performance': 4.4, 'resource': 4.4, 'target': 4.4,
    'adventure': 4.4, 'arrival': 4.3, 'attraction': 4.2, 'destination': 4.3,
    'shortcut': 3.8, 'budget': 4.4, 'scenery': 4.1, 'vacuum': 4.0,
    'baggage': 4.1, 'booking': 4.2, 'fare': 4.0, 'excursion': 3.8,

    // B2 - Spécialisé / Avancé (Zipf < 3.5)
    'troubleshoot': 3.1, 'breakthrough': 3.4, 'streamline': 3.2, 'workflow': 3.4,
    'deployment': 3.3, 'milestone': 3.4, 'itinerary': 3.4, 'accommodations': 3.3,
    'empathy': 3.4, 'resilience': 3.3, 'consensus': 3.4, 'ambiguity': 3.2,
    'bias': 3.4, 'overwhelming': 3.4, 'applicant': 3.4, 'assessment': 3.4,
    'capacity': 3.4, 'competence': 3.3, 'efficiency': 3.4, 'enterprise': 3.4,
    'evaluation': 3.4, 'expertise': 3.4, 'flexibility': 3.4, 'implement': 3.4,
    'innovation': 3.4, 'insight': 3.4, 'leadership': 3.4, 'maintenance': 3.4,
    'negotiate': 3.3, 'objective': 3.4, 'productivity': 3.4, 'strategy': 3.4,
    'supervisor': 3.4, 'appliance': 3.3, 'hospitality': 3.4, 'insurance': 3.4,
    'landmark': 3.4, 'suburb': 3.3, 'terminal': 3.4, 'transit': 3.4,
    'transportation': 3.4, 'awareness': 3.4, 'concept': 3.4, 'confidence': 3.4,
    'consequence': 3.4, 'diversity': 3.4, 'equality': 3.4, 'ethics': 3.4,
    'expectation': 3.4, 'identity': 3.4, 'influence': 3.4, 'integrity': 3.3,
    'interaction': 3.4, 'justice': 3.4, 'liberty': 3.4, 'motivation': 3.4,
    'perception': 3.4, 'principle': 3.4, 'reputation': 3.4, 'responsibility': 3.4,
    'sincerity': 3.2, 'solidarity': 3.3, 'tolerance': 3.4,
  };

  /// Calcule ou estime le score de fréquence Zipf (1.0 à 7.0)
  double getFrequencyScore(String term, {String language = 'en'}) {
    final clean = term.trim().toLowerCase();
    if (_curatedEnglishZipf.containsKey(clean)) {
      return _curatedEnglishZipf[clean]!;
    }

    // Heuristique linguistique universelle si le mot n'est pas dans le dictionnaire de base :
    // La longueur du mot et sa composition morphologique sont fortement corrélées à sa rareté.
    final len = clean.length;
    if (len <= 4) {
      return 5.2; // Mot court non répertorié : souvent A2
    } else if (len <= 7) {
      return 4.2; // Mot moyen : B1
    } else if (len <= 10) {
      return 3.6; // Mot plus long : B1-B2
    } else {
      return 3.1; // Mot complexe/long : B2
    }
  }

  /// Détermine le niveau CECRL (A1, A2, B1, B2) à partir du score de fréquence
  CefrLevel determineLevel(String term, {String language = 'en'}) {
    final score = getFrequencyScore(term, language: language);
    if (score >= CefrLevel.a1.minZipf) {
      return CefrLevel.a1;
    } else if (score >= CefrLevel.a2.minZipf) {
      return CefrLevel.a2;
    } else if (score >= CefrLevel.b1.minZipf) {
      return CefrLevel.b1;
    } else {
      return CefrLevel.b2;
    }
  }
}
