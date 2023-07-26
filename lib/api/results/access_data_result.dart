import 'dart:convert';

class AccessDataResult {
  final bool updateAvailable;
  final bool? updateMandatory;
  final String? updateDetails;
  final bool messagePresent;
  final String? messageTitle, messageDetails;
  final bool? messageLinkPresent;
  final String? messageLinkName, messageLink;

  AccessDataResult(
    this.updateAvailable,
    this.updateMandatory,
    this.updateDetails,
    this.messagePresent,
    this.messageTitle,
    this.messageDetails,
    this.messageLinkPresent,
    this.messageLinkName,
    this.messageLink,
  );

  factory AccessDataResult.fromJson(String body) {
    dynamic json = jsonDecode(body);

    return AccessDataResult(
      json['updateAvailable'],
      json['updateNeeded'],
      json['updateDetails'],
      json['messagePresent'],
      json['messageTitle'],
      json['messageDetails'],
      json['messageLinkPresent'],
      json['messageLinkLabel'],
      json['messageLink'],
    );
  }
}
