import 'package:flutter/material.dart';
import 'package:quimify_client/api/ads.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

class QuimifyScaffold extends StatefulWidget {
  const QuimifyScaffold({
    Key? key,
    this.showBannerAd = true,
    required this.header,
    required this.body,
  }) : super(key: key);

  final bool showBannerAd;
  final Widget header, body;

  @override
  State<QuimifyScaffold> createState() => _QuimifyScaffoldState();
}

class _QuimifyScaffoldState extends State<QuimifyScaffold> {
  static const double _bodyRoundedCornersRadius = 25;
  static const double _bannerAdMaxHeight = 50;

  Widget? _bannerAd;
  bool _loadedBannerAd = false;

  _onBannerAdLoaded() => setState(() => _loadedBannerAd = true);

  _loadBannerAd(double screenWidth) async => _bannerAd = await Ads()
      .getBannerAd(Size(screenWidth, _bannerAdMaxHeight), _onBannerAdLoaded);

  @override
  Widget build(BuildContext context) {
    if (widget.showBannerAd && !_loadedBannerAd) {
      _loadBannerAd(MediaQuery.of(context).size.width);
    }

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
          if (_loadedBannerAd) // TODO constant banner?
            Padding(
              padding: const EdgeInsets.only(
                top: _bodyRoundedCornersRadius, // To counter overlap
              ),
              child: SafeArea(
                top: false,
                child: _bannerAd!,
              ),
            ),
        ],
      ),
    );
  }
}
