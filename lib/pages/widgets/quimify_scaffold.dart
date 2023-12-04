import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

class QuimifyScaffold extends StatefulWidget {
  const QuimifyScaffold({
    Key? key,
    this.showBannerAd = true,
    required this.adPlacementName,
    required this.header,
    required this.body,
  }) : super(key: key);

  const QuimifyScaffold.noAd({
    super.key,
    required this.header,
    required this.body,
  })  : showBannerAd = false,
        adPlacementName = '';

  final String adPlacementName;
  final Widget header, body;

  final bool showBannerAd;

  @override
  State<QuimifyScaffold> createState() => _QuimifyScaffoldState();
}

class _QuimifyScaffoldState extends State<QuimifyScaffold> {
  static const double _bodyRoundedCornersRadius = 25;

  bool _bannerAdLoaded = false;

  _onBannerAdLoaded() {
    if (!_bannerAdLoaded) {
      setState(() => _bannerAdLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // To avoid keyboard resizing
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SignedSpacingColumn(
        spacing: -_bodyRoundedCornersRadius,
        stackingOrder: StackingOrder.lastOnTop,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: quimifyGradient(),
            ),
            padding: const EdgeInsets.only(
              bottom: _bodyRoundedCornersRadius,
            ),
            child: widget.header,
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              // To avoid rounded corners overflow
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_bodyRoundedCornersRadius),
                ),
              ),
              child: widget.body,
            ),
          ),
          if (widget.showBannerAd)
            Padding(
              padding: const EdgeInsets.only(
                top: _bodyRoundedCornersRadius, // To counter overlap
              ),
              child: SizedBox(
                child: SafeArea(
                  top: false,
                  child: Ads().banner(
                    widget.adPlacementName,
                    _bannerAdLoaded,
                    _onBannerAdLoaded,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
