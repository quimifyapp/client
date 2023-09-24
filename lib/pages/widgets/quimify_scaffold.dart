import 'package:flutter/material.dart';
import 'package:quimify_client/api/ads.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
final small = MobileSmallView(
      bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
      header: widget.header,
      body: widget.body,
      loadedBannerAd: _loadedBannerAd,
      bannerAd: _bannerAd,
    );
    final mobile = MobileView(
      bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
      header: widget.header,
      body: widget.body,
      loadedBannerAd: _loadedBannerAd,
      bannerAd: _bannerAd,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, // To avoid keyboard resizing
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ResponsiveBreakpoints.of(context).smallerThan(MOBILE)
          ? small
          : mobile,
    );
  }
}

class MobileSmallView extends StatelessWidget {
  const MobileSmallView({
    super.key,
    required double bodyRoundedCornersRadius,
    required this.header,
    required this.body,
    required bool loadedBannerAd,
    required Widget? bannerAd,
  })  : _bodyRoundedCornersRadius = bodyRoundedCornersRadius,
        _loadedBannerAd = loadedBannerAd,
        _bannerAd = bannerAd;

  final double _bodyRoundedCornersRadius;
  final Widget header;
  final Widget body;
  final bool _loadedBannerAd;
  final Widget? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: _Header(
            bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
            header: header,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              _Body(
                bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
                body: body,
              ),
              if (_loadedBannerAd) // TODO constant banner?
                _BannerAd(
                  bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
                  bannerAd: _bannerAd,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    super.key,
    required double bodyRoundedCornersRadius,
    required this.header,
    required this.body,
    required bool loadedBannerAd,
    required Widget? bannerAd,
  })  : _bodyRoundedCornersRadius = bodyRoundedCornersRadius,
        _loadedBannerAd = loadedBannerAd,
        _bannerAd = bannerAd;

  final double _bodyRoundedCornersRadius;
  final Widget header;
  final Widget body;
  final bool _loadedBannerAd;
  final Widget? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SignedSpacingColumn(
      spacing: -_bodyRoundedCornersRadius,
      stackingOrder: StackingOrder.lastOnTop,
      children: [
        _Header(
          bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
          header: header,
        ),
        Expanded(
          child: _Body(
            bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
            body: body,
          ),
        ),
        if (_loadedBannerAd) // TODO constant banner?
          _BannerAd(
            bodyRoundedCornersRadius: _bodyRoundedCornersRadius,
            bannerAd: _bannerAd,
          ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required double bodyRoundedCornersRadius,
    required this.body,
  }) : _bodyRoundedCornersRadius = bodyRoundedCornersRadius;

  final double _bodyRoundedCornersRadius;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Container(
        clipBehavior: Clip.hardEdge,
        // To avoid rounded corners overflow
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_bodyRoundedCornersRadius),
          ),
        ),
        child: body,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required double bodyRoundedCornersRadius,
    required this.header,
  }) : _bodyRoundedCornersRadius = bodyRoundedCornersRadius;

  final double _bodyRoundedCornersRadius;
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: quimifyGradient(),
      ),
      padding: EdgeInsets.only(
        bottom: _bodyRoundedCornersRadius,
      ),
      child: header,
    );
  }
}

class _BannerAd extends StatelessWidget {
  const _BannerAd({
    required double bodyRoundedCornersRadius,
    required Widget? bannerAd,
  })  : _bodyRoundedCornersRadius = bodyRoundedCornersRadius,
        _bannerAd = bannerAd;

  final double _bodyRoundedCornersRadius;
  final Widget? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: _bodyRoundedCornersRadius, // To counter overlap
      ),
      child: SafeArea(
        top: false,
        child: _bannerAd!,
      ),
    );
  }
}
