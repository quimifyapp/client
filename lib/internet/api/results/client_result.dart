import 'dart:convert';

class ClientResult {
  final bool updateAvailable;
  final bool? updateNeeded;
  final String? updateDetails;

  final bool messagePresent;
  final String? messageTitle, messageDetails;
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
    this.updateDetails,
    this.messagePresent,
    this.messageTitle,
    this.messageDetails,
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
      json['updateDetails'],
      json['messagePresent'],
      json['messageTitle'],
      json['messageDetails'],
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
