import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:flutter/material.dart';

class QuimifyCard extends StatelessWidget {
  const QuimifyCard({
    super.key,
    this.width,
    required this.title,
    required this.structure,
    required this.autoSizeGroup,
    required this.name,
    required this.page,
  })  : _isLocked = false,
        customBody = null;

  const QuimifyCard.custom({
    super.key,
    this.width,
    required this.title,
    required this.customBody,
    required this.page,
  })  : _isLocked = false,
        name = null,
        structure = null,
        autoSizeGroup = null;

  const QuimifyCard.comingSoon({
    super.key,
    this.width,
    required this.title,
    this.customBody,
  })  : _isLocked = true,
        structure = null,
        autoSizeGroup = null,
        name = null,
        page = null;

  final double? width;

  final String title;
  final Widget? customBody;
  final String? structure;
  final AutoSizeGroup? autoSizeGroup;
  final String? name;
  final Widget? page;

  final bool _isLocked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: page != null
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => page!,
                ),
              )
          : () => quimifyComingSoonDialog.show(context),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        // To avoid rounded corners overflow:
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: quimifyGradient,
              ),
              padding: const EdgeInsets.only(
                top: 13 + 1,
                bottom: 13 - 1,
                left: 20,
                right: 20,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (customBody == null && !_isLocked)
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.only(
                  top: 13 - 2,
                  bottom: 13 + 2,
                  left: 20,
                  right: 20,
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      structure!,
                      maxLines: 1,
                      stepGranularity: 0.1,
                      group: autoSizeGroup,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: quimifyTeal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            if (customBody == null && _isLocked)
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/icons/lock.png',
                        height: 35,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Próximamente',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (customBody != null) customBody!,
          ],
        ),
      ),
    );
  }
}
