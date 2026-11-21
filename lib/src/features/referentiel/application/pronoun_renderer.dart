import '../domain/conjugation.dart';
import '../domain/grammar_profile.dart';

class PronounRenderer {
  PronounRenderer._();

  /// Reconstruit l'affichage du pronom sujet + forme (§3.2) en appliquant `elision_pattern`
  /// sauf si `form.noElision == true` ou s'il s'agit de l'impératif (`IMP`).
  static String renderSubjectWithForm(
    ConjugationForm form,
    GrammarProfile profile,
  ) {
    if (form.mood == 'IMP' || form.mood == 'PART') {
      return form.form;
    }
    final pronouns = profile.subjectPronouns;
    if (pronouns == null) return form.form;

    final person = form.person;
    final number = form.number;
    if (person == null || number == null) return form.form;

    final key = '${person}_$number';
    final spec = pronouns[key];
    if (spec == null) return form.form;

    final useElided = spec.elided != null &&
        !form.noElision &&
        profile.elisionPattern != null &&
        RegExp(profile.elisionPattern!, caseSensitive: false).hasMatch(form.form.trimLeft());

    if (useElided) {
      return '${spec.elided}${form.form}';
    }
    return '${spec.form} ${form.form}';
  }
}
