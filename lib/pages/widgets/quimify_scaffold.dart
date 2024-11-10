import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/subsription_service.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

class QuimifyScaffold extends StatefulWidget {
  const QuimifyScaffold({
    Key? key,
    this.showBannerAd = true,
    required this.bannerAdName,
    required this.header,
    required this.body,
  }) : super(key: key);

  const QuimifyScaffold.noAd({
    super.key,
    required this.header,
    required this.body,
  })  : showBannerAd = false,
        bannerAdName = '';

  final String bannerAdName;
  final Widget header, body;

  final bool showBannerAd;

  @override
  State<QuimifyScaffold> createState() => _QuimifyScaffoldState();
}

class _QuimifyScaffoldState extends State<QuimifyScaffold> {
  final _subscriptionService = getIt<SubscriptionService>();
  bool _isSubscribed = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _isSubscribed = _subscriptionService.isSubscribed;
    _subscription =
        _subscriptionService.subscriptionStream.listen((isSubscribed) {
      if (mounted) {
        setState(() {
          _isSubscribed = isSubscribed;
        });
      }
    });
  }

  static const double _bodyRoundedCornersRadius = 25;
  static const double _bannerAdMaxHeight = 60; // TODO responsive, 50 smaller

  BannerAd? _bannerAd;
  bool _triedLoadingBannerAd = false;

  @override
  dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _subscription?.cancel();
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
          if (_bannerAd != null && !_isSubscribed)
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
