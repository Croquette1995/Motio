class SeedWord {
  final String term;
  final String translation;
  final String contextSentence;
  final String category;
  final String level;

  const SeedWord({
    required this.term,
    required this.translation,
    required this.contextSentence,
    required this.category,
    required this.level,
  });
}

const List<SeedWord> initialWordsSeed = [
  // --- Category: Work & Tech (10 words) ---
  SeedWord(
    term: 'deadline',
    translation: 'date limite',
    contextSentence: 'We need to work extra hours to meet the tight deadline.',
    category: 'Work & Tech',
    level: 'B1',
  ),
  SeedWord(
    term: 'troubleshoot',
    translation: 'dépanner / diagnostiquer',
    contextSentence: 'The IT team helped troubleshoot the network connection issue.',
    category: 'Work & Tech',
    level: 'B2',
  ),
  SeedWord(
    term: 'brainstorm',
    translation: 'faire un remue-méninges',
    contextSentence: 'Let\'s brainstorm some innovative ideas for the new marketing campaign.',
    category: 'Work & Tech',
    level: 'B1',
  ),
  SeedWord(
    term: 'breakthrough',
    translation: 'avancée majeure / percée',
    contextSentence: 'The research team achieved a significant technological breakthrough.',
    category: 'Work & Tech',
    level: 'B2',
  ),
  SeedWord(
    term: 'streamline',
    translation: 'rationaliser / simplifier',
    contextSentence: 'The manager automated tasks to streamline the approval process.',
    category: 'Work & Tech',
    level: 'B2',
  ),
  SeedWord(
    term: 'workflow',
    translation: 'flux de travail',
    contextSentence: 'Adopting agile methodology improved our daily development workflow.',
    category: 'Work & Tech',
    level: 'B1',
  ),
  SeedWord(
    term: 'deployment',
    translation: 'déploiement',
    contextSentence: 'The software deployment went smoothly without any server downtime.',
    category: 'Work & Tech',
    level: 'B2',
  ),
  SeedWord(
    term: 'feedback',
    translation: 'retour d\'information',
    contextSentence: 'Constructive feedback from users helped us enhance the user interface.',
    category: 'Work & Tech',
    level: 'B1',
  ),
  SeedWord(
    term: 'milestone',
    translation: 'jalon / étape clé',
    contextSentence: 'Reaching ten thousand active users was a key milestone for the startup.',
    category: 'Work & Tech',
    level: 'B2',
  ),
  SeedWord(
    term: 'collaborate',
    translation: 'collaborer',
    contextSentence: 'Engineers and designers collaborate closely to build intuitive products.',
    category: 'Work & Tech',
    level: 'B1',
  ),

  // --- Category: Daily Life & Travel (10 words) ---
  SeedWord(
    term: 'commute',
    translation: 'trajet quotidien',
    contextSentence: 'Her morning commute by train takes about forty-five minutes.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'itinerary',
    translation: 'itinéraire',
    contextSentence: 'We planned a detailed travel itinerary for our week in Scotland.',
    category: 'Daily Life & Travel',
    level: 'B2',
  ),
  SeedWord(
    term: 'grocery',
    translation: 'courses alimentaires / épicerie',
    contextSentence: 'Don\'t forget to buy fresh produce during your grocery shopping.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'accommodations',
    translation: 'hébergement / logement',
    contextSentence: 'They booked budget-friendly accommodations near the city center.',
    category: 'Daily Life & Travel',
    level: 'B2',
  ),
  SeedWord(
    term: 'luggage',
    translation: 'bagages',
    contextSentence: 'Make sure to attach an identification tag to your luggage before flying.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'delay',
    translation: 'retard',
    contextSentence: 'The flight was delayed due to severe weather conditions.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'reservation',
    translation: 'réservation',
    contextSentence: 'I made a dinner reservation for two at the Italian restaurant.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'sightseeing',
    translation: 'visite touristique',
    contextSentence: 'They spent the sunny afternoon sightseeing around historical monuments.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'shortcut',
    translation: 'raccourci',
    contextSentence: 'Taking a shortcut through the park saved us fifteen minutes.',
    category: 'Daily Life & Travel',
    level: 'B1',
  ),
  SeedWord(
    term: 'budget',
    translation: 'budget',
    contextSentence: 'Traveling off-season helps backpackers keep a reasonable budget.',
    category: 'Daily Life & Travel',
    level: 'B2',
  ),

  // --- Category: Social & Abstract (10 words) ---
  SeedWord(
    term: 'empathy',
    translation: 'empathie',
    contextSentence: 'Active listening is essential for demonstrating genuine empathy toward others.',
    category: 'Social & Abstract',
    level: 'B2',
  ),
  SeedWord(
    term: 'resilience',
    translation: 'résilience',
    contextSentence: 'Overcoming setbacks requires mental resilience and perseverance.',
    category: 'Social & Abstract',
    level: 'B2',
  ),
  SeedWord(
    term: 'compromise',
    translation: 'compromis',
    contextSentence: 'Both sides agreed to a mutual compromise to resolve the disagreement.',
    category: 'Social & Abstract',
    level: 'B1',
  ),
  SeedWord(
    term: 'consensus',
    translation: 'consensus',
    contextSentence: 'After hours of negotiation, the committee finally reached a consensus.',
    category: 'Social & Abstract',
    level: 'B2',
  ),
  SeedWord(
    term: 'ambiguity',
    translation: 'ambiguïté',
    contextSentence: 'Clear instructions reduce ambiguity and eliminate confusion among teammates.',
    category: 'Social & Abstract',
    level: 'B2',
  ),
  SeedWord(
    term: 'bias',
    translation: 'biais / parti pris',
    contextSentence: 'Being aware of cognitive bias helps us make more rational decisions.',
    category: 'Social & Abstract',
    level: 'B2',
  ),
  SeedWord(
    term: 'mindset',
    translation: 'état d\'esprit',
    contextSentence: 'Cultivating a growth mindset encourages learning from mistakes.',
    category: 'Social & Abstract',
    level: 'B1',
  ),
  SeedWord(
    term: 'overwhelming',
    translation: 'accablant / écrasant',
    contextSentence: 'Breaking large tasks into smaller steps makes them less overwhelming.',
    category: 'Social & Abstract',
    level: 'B2',
  ),
  SeedWord(
    term: 'perspective',
    translation: 'perspective / point de vue',
    contextSentence: 'Traveling broadens your worldview and offers a fresh perspective on life.',
    category: 'Social & Abstract',
    level: 'B1',
  ),
  SeedWord(
    term: 'trust',
    translation: 'confiance',
    contextSentence: 'Mutual trust is the foundation of any lasting professional relationship.',
    category: 'Social & Abstract',
    level: 'B1',
  ),
];
