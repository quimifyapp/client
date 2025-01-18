import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

class QuimifyScaffold extends StatefulWidget {
  const QuimifyScaffold({
    Key? key,
    this.showBannerAd = true,
    required this.bannerAdName,
    required this.header,
    required this.body,
    this.fab,
  }) : super(key: key);

  const QuimifyScaffold.noAd({
    super.key,
    required this.header,
    required this.body,
    this.fab,
  })  : showBannerAd = false,
        bannerAdName = '';

  final String bannerAdName;
  final Widget header, body;
  final Widget? fab;

  final bool showBannerAd;

  @override
  State<QuimifyScaffold> createState() => _QuimifyScaffoldState();
}

class _QuimifyScaffoldState extends State<QuimifyScaffold> {
  static const double _bodyRoundedCornersRadius = 25;
  static const double _bannerAdMaxHeight = 60; // TODO responsive, 50 smaller

  BannerAd? _bannerAd;
  bool _triedLoadingBannerAd = false;

  @override
  dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBannerAd && !_triedLoadingBannerAd) {
      _triedLoadingBannerAd = true;

      Ads().loadBanner(
        Size(MediaQuery.of(context).size.width, _bannerAdMaxHeight),
        (Ad ad) => setState(() => _bannerAd = ad as BannerAd),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, // To avoid keyboard resizing
      backgroundColor: QuimifyColors.background(context),
      floatingActionButton: widget.fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SignedSpacingColumn(
        spacing: -_bodyRoundedCornersRadius,
        stackingOrder: StackingOrder.lastOnTop,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: QuimifyColors.gradient(),
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
                color: QuimifyColors.background(context),
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
