import 'package:flutter/material.dart';
import 'package:quimify_client/api/ads.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';

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
  static const double _bannerAdHeight = 50;

  Widget? _bannerAd;
  bool _loadedBannerAd = false;

  _onBannerAdLoaded() => setState(() => _loadedBannerAd = true);

  _loadBannerAd(double screenWidth) async => _bannerAd = await Ads()
      .getBannerAd(Size(screenWidth, _bannerAdHeight), _onBannerAdLoaded);

  @override
  Widget build(BuildContext context) {
    if (widget.showBannerAd && !_loadedBannerAd) {
      _loadBannerAd(MediaQuery.of(context).size.width);
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: quimifyGradient,
      ),
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            widget.header,
            Expanded(
              child: Container(
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: widget.body,
              ),
            ),
            if (_loadedBannerAd)
              Container(
                color: Theme.of(context).colorScheme.background,
                child: SafeArea(
                  top: false,
                  child: _bannerAd!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
