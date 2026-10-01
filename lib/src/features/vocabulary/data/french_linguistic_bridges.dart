/// Dictionnaire d'ancrage cognitif et de ponts linguistiques franco-anglais.
/// Relie les mots anglais à leurs racines françaises/latines, sens littéraux imagés ou faux-amis.
const Map<String, String> frenchLinguisticBridges = {
  // --- Work & Tech ---
  'deadline':
      'Littéralement « ligne de mort ». À l\'origine, limite qu\'un prisonnier ne pouvait franchir dans un camp sous peine d\'être abattu. Au sens figuré : date limite incontournable.',
  'troubleshoot':
      'Composé de « trouble » (ennuis/panne, de l\'ancien français torbler) + « shoot » (tirer). Métaphore américaine : « abattre les problèmes », soit diagnostiquer et dépanner.',
  'brainstorm':
      'Composé de « brain » (cerveau) + « storm » (tempête). Littéralement « tempête de cerveau », en français : faire un remue-méninges.',
  'breakthrough':
      'Composé de « break » (briser) + « through » (à travers). Percer les lignes de défense adverses -> au figuré : avancée majeure ou percée technologique décisive.',
  'streamline':
      'De « stream » (courant d\'eau) + « line » (ligne). Donner une forme profilée aérodynamique -> au figuré : rationaliser, fluidifier et simplifier un processus.',
  'workflow':
      'Composé de « work » (travail) + « flow » (flux, écoulement). Littéralement le « flux de travail » ou l\'enchaînement des étapes de production.',
  'deployment':
      'Emprunt direct à l\'ancien français « desployer » (déployer, étendre). En informatique : mise en production ou déploiement opérationnel d\'une application.',
  'feedback':
      'Composé de « feed » (nourrir) + « back » (en retour). Littéralement « nourrir en retour » -> retour d\'information, réaction ou évaluation constructive.',
  'milestone':
      'De « mile » (mille) + « stone » (pierre). Les bornes kilométriques en pierre de l\'époque romaine -> au figuré : jalon ou étape clé d\'un projet.',
  'collaborate':
      'Du latin « collaborare » (cum = ensemble + laborare = travailler). Parenté transparente directe avec le mot français « collaborer ».',

  // --- Travel & Daily Life ---
  'commute':
      'Du latin « commutare » (échanger). Désignait l\'abonnement de train à tarif forfaitaire (« commuted fare ») -> par métonymie : le trajet régulier domicile-travail.',
  'itinerary':
      'Du bas-latin « itinerarium », emprunté par l\'anglais au moyen français « itinéraire ». Mot transparent.',
  'grocery':
      'Issu de l\'ancien français « grossier » (commerçant vendant en gros) -> a évolué en anglais vers l\'épicerie et les courses alimentaires du quotidien.',
  'accommodations':
      'Issu du français « accommoder » / latin « accommodare » (adapter, loger convenablement) -> hébergement ou logement de voyage.',
  'accommodation':
      'Issu du français « accommoder » / latin « accommodare » (adapter, loger convenablement) -> hébergement ou logement de voyage.',
  'luggage':
      'Dérivé du verbe « lug » (traîner péniblement une lourde charge) -> désigne l\'ensemble des bagages qu\'on transporte.',
  'baggage':
      'Emprunt direct à l\'ancien français « bague » (paquet, bagage) -> bagages de voyage.',
  'delay':
      'Emprunt direct à l\'ancien français « delaier » (retarder, différer) -> retard, report.',
  'reservation':
      'Parent transparent direct du français « réservation » (du latin reservare).',
  'booking':
      'De « book » (livre, registre où l\'on inscrivait manuellement les clients) -> réservation d\'un voyage, d\'un hôtel ou d\'un billet.',
  'sightseeing':
      'Composé de « sight » (vue, curiosité remarquable) + « seeing » (regarder). Littéralement « voir les curiosités » -> tourisme, visite guidée.',
  'shortcut':
      'Composé de « short » (court) + « cut » (couper). « Couper court » à travers champ -> un raccourci.',
  'budget':
      'Emprunté au français médiéval « bougette » (sacoche en cuir du trésorier). L\'anglais l\'a adopté puis réexporté vers le français moderne !',

  // --- Communication, Soft Skills & Society ---
  'empathy':
      'Du grec « empatheia » (ressentir de l\'intérieur), calque transparent du mot français « empathie ».',
  'resilience':
      'Du latin « resilire » (rebondir, reprendre sa forme après un choc). Identique au français « résilience ».',
  'compromise':
      'Emprunt direct à l\'ancien français « compromis » (promesse mutuelle de respecter l\'arbitrage).',
  'consensus':
      'Emprunt direct au latin « consensus » (accord unanime des sentiments). Identique au français.',
  'ambiguity':
      'Emprunté au moyen français « ambiguïté » (du latin ambiguus = qui va dans deux directions).',
  'bias':
      'Issu de l\'ancien français « biais » (ligne oblique, puis penchant, parti pris). Un biais cognitif est une inclinaison qui dévie de la neutralité.',
  'mindset':
      'Composé de « mind » (esprit) + « set » (fixé, configuré). La configuration mentale d\'une personne -> état d\'esprit, mentalité.',
  'overwhelming':
      'Du verbe « whelm » (engloutir sous une vague). Une émotion ou tâche qui vous submerge complètement -> écrasant, accablant.',
  'perspective':
      'Issu du latin « perspicere » (regarder attentivement à travers) via le français « perspective ».',
  'trust':
      'De racine germanique désignant ce qui est solide et loyal -> la confiance mutuelle.',
  'ability':
      'Issu de l\'ancien français « ablete » (issu du latin habilitas -> habileté) -> capacité, compétence.',
  'achievement':
      'Emprunt à l\'ancien français « achever » (venir à chef, mener à terme avec succès) -> accomplissement remarquable, réussite.',
  'analyze':
      'Du français « analyser » (du grec analysis -> décomposition des éléments constitutifs).',
  'applicant':
      'Du verbe « apply » (postuler, du français appliquer / s\'adresser à) -> candidat, postulant.',
  'assessment':
      'Du latin « assessare » (s\'asseoir auprès d\'un juge pour évaluer les impôts) -> évaluation, bilan chiffré ou qualitatif.',
  'benefit':
      'Issu de l\'ancien français « bienfait » (latin beneficium) -> avantage, profit, bénéfice.',
  'capacity':
      'Parent transparent du français « capacité » (du latin capacitas = volume que l\'on peut contenir).',
  'challenge':
      'Emprunt à l\'ancien français « chalenge » (calomnie, accusation, puis défi au combat).',
  'competence':
      'Parent direct et transparent du mot français « compétence ».',
  'efficiency':
      'Du latin « efficientia » -> capacité à produire un résultat maximal avec le minimum de ressources (efficacité, rendement).',
  'enterprise':
      'Emprunt direct au français « entreprise » (ce que l\'on entreprend).',
  'evaluation':
      'Parent direct et transparent du français « évaluation ».',
  'expertise':
      'Emprunt direct au mot français « expertise » (connaissance approfondie d\'un expert).',
  'flexibility':
      'Parent direct du français « flexibilité » (du latin flexibilis = souple, adaptable).',
  'growth':
      'Du verbe germanique « grow » (grandir) -> croissance, développement d\'une entreprise ou d\'un projet.',
  'implement':
      'Du latin « implere » (remplir, accomplir jusqu\'au bout) -> mettre en œuvre, exécuter concrètement un plan.',
  'innovation':
      'Parent transparent direct du français « innovation » (du latin innovare = introduire de la nouveauté).',
  'insight':
      'Composé de « in » (dedans) + « sight » (vue). « Voir à l\'intérieur » d\'un problème -> compréhension intime, éclairage pertinent.',
  'leadership':
      'De « leader » (guider, mener une route) + suffixe « -ship » -> capacité à diriger et inspirer une équipe.',
  'maintenance':
      'Emprunt direct à l\'ancien français « maintenance » (action de maintenir en bon état de fonctionnement).',
  'negotiate':
      'Du latin « negotiari » (faire des affaires, du mot negotium = négociation). Mot transparent.',
  'objective':
      'Parent transparent direct du français « objectif ».',
  'performance':
      'Emprunté par l\'anglais à l\'ancien français « parformer » (accomplir entièrement) avant d\'être réadopté en français !',
  'productivity':
      'Parent transparent du français « productivité ».',
  'promotion':
      'Parent transparent du français « promotion » (du latin promovere = mouvoir vers l\'avant, faire progresser).',
  'qualify':
      'Du français « qualifier » (du latin qualis = quelle nature) -> remplir les critères requis.',
  'resource':
      'Issu de l\'ancien français « ressourse » (source qui rejaillit) -> moyen disponible, ressource.',
  'strategy':
      'Parent transparent du français « stratégie » (du grec strategos = art du commandement).',
  'supervisor':
      'Du latin « super » (au-dessus) + « videre » (voir) -> celui qui surveille et supervise une équipe.',
  'target':
      'Issu de l\'ancien français « targe » (petit bouclier rond servant de cible d\'entraînement au tir) -> la cible, l\'objectif chiffré.',
  'adventure':
      'Emprunt direct au français « aventure » (du latin advenire = ce qui doit arriver).',
  'appliance':
      'Dérivé de « apply » (mettre en usage) -> appareil ménager ou dispositif utilitaire.',
  'arrival':
      'Emprunt direct à l\'ancien français « ariver » (aborder la rive) -> arrivée.',
  'attraction':
      'Parent transparent du français « attraction ».',
  'destination':
      'Parent transparent du français « destination ».',
  'direction':
      'Parent transparent du français « direction ».',
  'discount':
      'Issu de l\'ancien français « descompter » (décompter, rabais sur le prix initial) -> remise commerciale.',
  'emergency':
      'Du latin « emergere » (surgir subitement à la surface) -> situation de crise urgente et inattendue.',
  'excursion':
      'Parent transparent direct du français « excursion » (du latin excurrere = sortir faire un tour).',
  'fare':
      'Du vieil anglais « faran » (voyager, faire route) -> prix du billet ou tarif du transport.',
  'guidebook':
      'Composé de « guide » (emprunt au français guide) + « book » (livre) -> guide touristique.',
  'habit':
      'Emprunt direct au français « habit » / latin « habitus » (manière d\'être acquise par la répétition).',
  'hospitality':
      'Parent transparent direct du français « hospitalité ».',
  'insurance':
      'Issu de l\'ancien français « enseurance » (assurance, promesse formelle de garantie) -> police d\'assurance.',
  'journey':
      'Emprunt direct à l\'ancien français « journée » (à l\'origine, la distance parcourue en un jour de voyage).',
  'landmark':
      'De « land » (terre) + « mark » (marque). Un repère géographique remarquable sur le paysage (monument, édifice).',
  'lifestyle':
      'Composé de « life » (vie) + « style » (style). Le mode de vie personnel.',
  'neighborhood':
      'De « neighbor » (voisin, de neigh = proche + boor = paysan) + « -hood » (condition) -> le quartier et ses habitants.',
  'passenger':
      'Emprunt direct à l\'ancien français « passager » (celui qui passe).',
  'passport':
      'Emprunt direct au français « passeport » (document permettant de passer un port).',
  'routine':
      'Emprunt direct au français « routine » (diminutif de route, le chemin habituel tracé).',
  'scenery':
      'Issu de « scene » (du français scène) -> le décor naturel grandiose ou le panorama.',
  'schedule':
      'Issu du latin « schedula » (petite feuille de papier portant une liste) -> emploi du temps, planning.',
  'souvenir':
      'Emprunt direct au mot français « souvenir » ! En anglais, désigne spécialement l\'objet rapporté en mémoire d\'un voyage.',
  'suburb':
      'Issu du latin « suburbium » (sub = sous/près + urbs = ville) -> la banlieue résidentielle.',
  'terminal':
      'Parent transparent direct du français « terminal » (la fin de ligne d\'un aéroport ou gare).',
  'ticket':
      'Issu de l\'ancien français « estiquette » (petite étiquette collée autorisant l\'entrée) ! Le mot anglais a été réimporté en français sous la forme « ticket ».',
  'tourism':
      'Dérivé de « tour » (du français tour, faire le tour) -> tourisme.',
  'transit':
      'Parent direct et transparent du mot français « transit ».',
  'transportation':
      'Parent direct et transparent du mot français « transport ».',
  'vacuum':
      'Du latin « vacuum » (vide) -> appareil qui aspire l\'air en créant un vide (aspirateur).',
  'vehicle':
      'Issu du français « véhicule » / latin « vehiculum » (moyen de transport).',
  'attitude':
      'Parent direct du français « attitude » (posture, disposition).',
  'awareness':
      'De « aware » (vigilant, attentif) -> prise de conscience, éveil de la vigilance sur un sujet.',
  'belief':
      'Du vieil anglais « geleafa » (foi, confiance) -> croyance, conviction intime.',
  'community':
      'Parent direct du français « communauté » (du latin communitas).',
  'concept':
      'Parent transparent du français « concept ».',
  'confidence':
      'Parent direct du français « confidence / confiance » (attention au faux-ami partiel : en anglais = confiance en soi ou assurance).',
  'consequence':
      'Parent transparent du français « conséquence ».',
  'culture':
      'Parent direct du français « culture ».',
  'diversity':
      'Parent direct du français « diversité ».',
  'emotion':
      'Parent direct du français « émotion » (du français émouvoir).',
  'equality':
      'Parent direct du français « égalité » (du latin aequalitas).',
  'ethics':
      'Parent direct du français « éthique » (du grec ethikos).',
  'expectation':
      'Du latin « expectare » (regarder dehors, attendre) -> attente, espérance projetée.',
  'freedom':
      'Composé de « free » (libre) + « -dom » (état) -> liberté d\'action et d\'expression.',
  'identity':
      'Parent direct du français « identité ».',
  'impression':
      'Parent transparent du français « impression ».',
  'influence':
      'Parent direct du français « influence ».',
  'integrity':
      'Parent direct du français « intégrité ».',
  'interaction':
      'Parent direct du français « interaction ».',
  'justice':
      'Parent transparent direct du français « justice ».',
  'knowledge':
      'Du verbe « know » (savoir) -> l\'ensemble des connaissances et savoirs accumulés.',
  'liberty':
      'Emprunt direct à l\'ancien français « liberté » (latin libertas) -> liberté au sens civique et politique.',
  'motivation':
      'Parent direct du français « motivation ».',
  'opinion':
      'Parent direct du français « opinion ».',
  'perception':
      'Parent direct du français « perception ».',
  'principle':
      'Parent direct du français « principe » (du latin principium = fondement).',
  'relation':
      'Parent direct du français « relation ».',
  'reputation':
      'Parent direct du français « réputation ».',
  'respect':
      'Parent direct du français « respect ».',
  'responsibility':
      'Parent direct du français « responsabilité ».',
  'sincerity':
      'Parent direct du français « sincérité ».',
  'society':
      'Parent direct du français « société ».',
  'solidarity':
      'Parent direct du français « solidarité ».',
  'tolerance':
      'Parent direct du français « tolérance ».',
  'value':
      'Emprunt direct à l\'ancien français « value » (valeur, mérite estimé).',
};
