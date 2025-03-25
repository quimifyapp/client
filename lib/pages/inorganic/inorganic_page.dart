import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/pages/accounts/sign_in_page.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/inorganic/nomenclature/nomenclature_page.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_help_dialog.dart';
import 'package:quimify_client/pages/practice_mode/difficulty_page.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class InorganicPage extends StatelessWidget {
  const InorganicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QuimifySectionTitle(
          title: 'Fórmulas y nombres',
          helpDialog: InorganicHelpDialog(),
        ),
        const SizedBox(height: 15),
        const QuimifyCard(
          body: {
            'H₂O': 'óxido de hidrógeno',
            'AuF₃': 'trifluoruro de oro',
            'HCl': 'ácido clorhídrico',
            'Fe₂S₃': 'sulfuro de hierro(III)',
            'PbBr₂': 'dibromuro de plomo',
            'H₂SO₃': 'ácido sulfuroso',
          },
          page: NomenclaturePage(),
        ),
        const QuimifySectionTitle(
          title: 'Practicar',
          helpDialog: comingSoonDialog,
        ),
        const SizedBox(height: 15),
        QuimifyCard.custom(
          customBody: {
            Icon(
              Icons.edit_note_rounded,
              size: 36,
              color: QuimifyColors.teal(),
            ): 'Practicar',
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
