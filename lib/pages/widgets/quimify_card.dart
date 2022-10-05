import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/pages/widgets/quimify_dialog.dart';
import 'package:cliente/pages/widgets/quimify_gradient.dart';
import 'package:cliente/pages/widgets/quimify_teal.dart';
import 'package:flutter/material.dart';

class QuimifyCard extends StatelessWidget {
  const QuimifyCard(
      {super.key,
      this.width,
      required this.title,
      required this.structure,
      required this.autoSizeGroup,
      required this.name,
      required this.page})
      : _isCustom = false,
        _isLocked = false,
        customBody = null;

  const QuimifyCard.custom(
      {super.key,
      this.width,
      required this.title,
      required this.customBody,
      required this.page})
      : _isCustom = true,
        _isLocked = false,
        name = null,
        structure = null,
        autoSizeGroup = null;

  const QuimifyCard.locked({super.key, this.width, required this.title})
      : _isCustom = false,
        _isLocked = true,
        customBody = null,
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

  final bool _isCustom;
  final bool _isLocked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: page != null
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return page!;
                  },
                ),
              );
            }
          : _isLocked
              ? () => const QuimifyDialog.message(
                    title: 'Falta muy poco',
                    details: 'Esta función pronto estará lista.',
                  ).show(context)
              : () {},
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
                  top: 17, bottom: 13, left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!_isCustom && !_isLocked)
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 25, right: 25),
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
            if (_isLocked)
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 15),
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
            if (_isCustom) customBody!,
          ],
        ),
      ),
    );
  }
}
