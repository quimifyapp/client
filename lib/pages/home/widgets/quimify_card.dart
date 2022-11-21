import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:flutter/material.dart';

class QuimifyCard extends StatelessWidget {
  const QuimifyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.page,
  })  : customTitle = null,
        _comingSoon = false;

  const QuimifyCard.custom({
    super.key,
    required this.customTitle,
    this.subtitle,
    required this.page,
  })  : title = null,
        _comingSoon = false;

  const QuimifyCard.comingSoon({
    super.key,
    required this.customTitle,
  })  : title = null,
        subtitle = 'Próximamente',
        page = null,
        _comingSoon = true;

  final Widget? customTitle;
  final String? title;
  final String? subtitle;
  final bool _comingSoon;
  final Widget? page;

  void _onPressed(BuildContext context) {
    if (page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => page!,
        ),
      );
    } else {
      quimifyComingSoonDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.surface,
        ),
        alignment: Alignment.centerLeft,
        // To avoid rounded corners overflow:
        clipBehavior: Clip.hardEdge,
        child: MaterialButton(
          splashColor: Colors.transparent,
          padding: const EdgeInsets.all(20),
          onPressed: () => _onPressed(context),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (customTitle != null) customTitle!,
                    if (customTitle == null)
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: quimifyTeal,
                        ),
                      ),
                    if (subtitle != null) ...[
                      const Spacer(),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!_comingSoon)
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 30,
                  color: quimifyTeal,
                ),
              if (_comingSoon)
                const Icon(
                  Icons.lock_rounded,
                  size: 26,
                  color: quimifyTeal,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
