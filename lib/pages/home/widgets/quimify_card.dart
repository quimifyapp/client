import 'dart:async';

import 'package:flutter/material.dart';

import 'package:quimify_client/pages/widgets/dialogs/messages/coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class QuimifyCard extends StatefulWidget {
  const QuimifyCard({
    super.key,
    required this.body,
    required this.page,
    this.paidFeature = false,
    this.onPressed,
  })  : customBody = null,
        comingSoonBody = null;

  const QuimifyCard.custom({
    super.key,
    required this.customBody,
    required this.page,
    this.paidFeature = false,
    this.onPressed,
  })  : body = null,
        comingSoonBody = null;

  const QuimifyCard.comingSoon({
    super.key,
    required this.comingSoonBody,
  })  : body = null,
        customBody = null,
        page = null,
        paidFeature = false,
        onPressed = null;

  final Map<String, String>? body;
  final Map<Widget, String>? customBody;
  final Widget? comingSoonBody;
  final Widget? page;
  final bool paidFeature;
  final VoidCallback? onPressed;

  @override
  State<QuimifyCard> createState() => _QuimifyCardState();
}

class _QuimifyCardState extends State<QuimifyCard> {
  late final Timer? _timer;
  late int _selector;

  @override
  initState() {
    super.initState();

    _selector = 0;

    int slides = widget.body != null
        ? widget.body!.length
        : widget.customBody != null
            ? widget.customBody!.length
            : 1;

    _timer = slides > 1
        ? Timer.periodic(
            const Duration(seconds: 2),
            (_) {
              if (slides != 0) {
                setState(() => _selector = (_selector + 1) % slides);
              }
            },
          )
        : null;
  }

  @override
  dispose() {
    if (_timer != null) {
      _timer.cancel();
    }

    super.dispose();
  }

  _onPressed(BuildContext context) async {
    if (widget.page == null) {
      comingSoonDialog(context).show(context);
      return;
    }

    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => widget.page!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: QuimifyColors.foreground(context),
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
                            style: TextStyle(
                              fontFamily: 'CeraProBoldCustom',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: QuimifyColors.teal(),
                            ),
                          ),
                        const Spacer(), // Between title and subtitle
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            widget.customBody != null
                                ? widget.customBody!.values.elementAt(_selector)
                                : widget.body != null
                                    ? widget.body!.values.elementAt(_selector)
                                    : context.l10n.soon,
                            style: TextStyle(
                              fontSize: 16,
                              color: QuimifyColors.primary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.comingSoonBody != null)
                Icon(
                  Icons.lock_rounded,
                  size: 26,
                  color: QuimifyColors.teal(),
                ),
              if (widget.comingSoonBody == null)
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 30,
                  color: QuimifyColors.teal(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
