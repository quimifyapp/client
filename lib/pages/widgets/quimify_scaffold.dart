import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/connections/ads.dart';
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
  static const double _bannerAdMaxHeight = 60; // TODO responsive, 50 smaller

  BannerAd? _bannerAd;

  @override
  dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBannerAd && _bannerAd == null) {
      Ads().loadBannerAd(
        Size(MediaQuery.of(context).size.width, _bannerAdMaxHeight),
        (Ad ad) => setState(() => _bannerAd = ad as BannerAd),
      );
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
          if (_bannerAd != null)
            Padding(
              padding: const EdgeInsets.only(
                top: _bodyRoundedCornersRadius, // To counter overlap
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
