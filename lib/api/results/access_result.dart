import 'dart:convert';

class AccessResult {
  final bool updateAvailable, messagePresent;
  final bool? updateMandatory, messageLinkPresent;
  final String? updateDetails,
      messageTitle,
      messageDetails,
      messageLinkName,
      messageLink;

  AccessResult(
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

  factory AccessResult.fromJson(String body) {
    dynamic json = jsonDecode(body);

    return AccessResult(
      json['updateAvailable'] as bool,
      json['updateMandatory'] as bool?,
      json['updateDetails'] as String?,
      json['messagePresent'] as bool,
      json['messageTitle'] as String?,
      json['messageDetails'] as String?,
      json['messageLinkPresent'] as bool?,
      json['messageLinkName'] as String?,
      json['messageLink'] as String?,
    );
  }
}
