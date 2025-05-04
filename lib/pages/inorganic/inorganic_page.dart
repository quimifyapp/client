import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/pages/accounts/sign_in_page.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/inorganic/nomenclature/nomenclature_page.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/practice_mode/difficulty_page.dart';
import 'package:quimify_client/pages/practice_mode/practice_help_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class InorganicPage extends StatelessWidget {
  const InorganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuimifySectionTitle(
          title: context.l10n.formulasAndNames,
          helpDialog: const InorganicHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard(
          body: {
            'H₂O': context.l10n.hydrogenOxide,
            'AuF₃': context.l10n.goldTrifluoride,
            'HCl': context.l10n.hydrochloricAcid,
            'Fe₂S₃': context.l10n.ironSulfide,
            'PbBr₂': context.l10n.leadBromide,
            'H₂SO₃': context.l10n.sulfurousAcid,
          },
          page: const NomenclaturePage(),
        ),
        QuimifySectionTitle(
          title: context.l10n.practice,
          helpDialog: const PracticeHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard.custom(
          customBody: {
            Icon(
              Icons.edit_note_rounded,
              size: 36,
              color: QuimifyColors.teal(),
            ): context.l10n.practice,
          },
          page: const DifficultyPage(),
          onPressed: () {
            final authService = AuthService();
            if (!authService.isSignedIn) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
              );
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DifficultyPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
