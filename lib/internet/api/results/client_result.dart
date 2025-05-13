import 'dart:convert';
import 'package:quimify_client/internet/language/language.dart';

class ClientResult {
  final bool updateAvailable;
  final bool? updateNeeded;
  final String? updateDetailsSpanish;
  final String? updateDetailsEnglish;

  final bool messagePresent;
  final String? messageTitleSpanish;
  final String? messageTitleEnglish;
  final String? messageDetailsSpanish;
  final String? messageDetailsEnglish;
  final bool? messageLinkPresent;
  final String? messageLinkName, messageLink;

  final bool bannerAdPresent;
  final String? bannerAdUnitId;

  final bool interstitialAdPresent;
  final int? interstitialAdPeriod, interstitialAdOffset;
  final String? interstitialAdUnitId;

  final bool rewardedAdPresent;
  final String? rewardedAdUnitId;

  ClientResult(
    this.updateAvailable,
    this.updateNeeded,
    this.updateDetailsSpanish,
    this.updateDetailsEnglish,
    this.messagePresent,
    this.messageTitleSpanish,
    this.messageTitleEnglish,
    this.messageDetailsSpanish,
    this.messageDetailsEnglish,
    this.messageLinkPresent,
    this.messageLinkName,
    this.messageLink,
    this.bannerAdPresent,
    this.bannerAdUnitId,
    this.interstitialAdPresent,
    this.interstitialAdPeriod,
    this.interstitialAdOffset,
    this.interstitialAdUnitId,
    this.rewardedAdPresent,
    this.rewardedAdUnitId,
  );

  factory ClientResult.fromJson(String body) {
    var json = jsonDecode(body);
    return ClientResult(
      json['updateAvailable'],
      json['updateNeeded'],
      json['updateDetailsSpanish'],
      json['updateDetailsEnglish'],
      json['messagePresent'],
      json['messageTitleSpanish'],
      json['messageTitleEnglish'],
      json['messageDetailsSpanish'],
      json['messageDetailsEnglish'],
      json['messageLinkPresent'],
      json['messageLinkLabel'],
      json['messageLink'],
      json['bannerAdPresent'],
      json['bannerAdUnitId'],
      json['interstitialAdPresent'],
      json['interstitialAdPeriod'],
      json['interstitialAdOffset'],
      json['interstitialAdUnitId'],
      json['rewardedAdPresent'],
      json['rewardedAdUnitId'],
    );
  }
}
