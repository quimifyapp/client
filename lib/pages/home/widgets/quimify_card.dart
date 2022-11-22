import 'dart:async';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:flutter/material.dart';

class QuimifyCard extends StatefulWidget {
  const QuimifyCard({
    super.key,
    required this.body,
    required this.page,
  })  : customBody = null,
        comingSoonBody = null;

  const QuimifyCard.custom({
    super.key,
    required this.customBody,
    required this.page,
  })  : body = null,
        comingSoonBody = null;

  const QuimifyCard.comingSoon({
    super.key,
    required this.comingSoonBody,
  })  : body = null,
        customBody = null,
        page = null;

  final Map<String, String>? body;
  final Map<Widget, String>? customBody;
  final Widget? comingSoonBody;
  final Widget? page;

  @override
  State<QuimifyCard> createState() => _QuimifyCardState();
}

class _QuimifyCardState extends State<QuimifyCard> {
  late final Timer? _timer;
  late int _selector;

  @override
  void initState() {
    _selector = 0;

    int slides = widget.body != null
        ? widget.body!.length
        : widget.customBody != null
            ? widget.customBody!.length
            : 1;

    _timer = slides > 1
        ? Timer.periodic(
            const Duration(seconds: 3),
            (_) {
              if (slides != 0) {
                setState(() => _selector = (_selector + 1) % slides);
              }
            },
          )
        : null;

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void _onPressed(BuildContext context) {
    if (widget.page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => widget.page!,
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
        // To avoid rounded corners overflow:
        clipBehavior: Clip.hardEdge,
        child: MaterialButton(
          padding: const EdgeInsets.all(20),
          splashColor: Colors.transparent,
          onPressed: () => _onPressed(context),
          child: Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Container(
                    key: ValueKey(_selector), // So it knows to animate it
                    alignment: Alignment.centerLeft, // Or else it glitches
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.comingSoonBody != null)
                          widget.comingSoonBody!,
                        if (widget.customBody != null)
                          widget.customBody!.keys.elementAt(_selector),
                        if (widget.body != null)
                          Text(
                            widget.body!.keys.elementAt(_selector),
                            style: const TextStyle(
                              fontFamily: 'CeraProBoldCustom',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: quimifyTeal,
                            ),
                          ),
                        const Spacer(), // Between title and subtitle
                        Text(
                          widget.customBody != null
                              ? widget.customBody!.values.elementAt(_selector)
                              : widget.body != null
                                  ? widget.body!.values.elementAt(_selector)
                                  : 'Próximamente',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.comingSoonBody != null)
                const Icon(
                  Icons.lock_rounded,
                  size: 26,
                  color: quimifyTeal,
                ),
              if (widget.comingSoonBody == null)
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 30,
                  color: quimifyTeal,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
