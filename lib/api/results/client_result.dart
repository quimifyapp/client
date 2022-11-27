import 'dart:convert';

class ClientResult {
  final bool updateAvailable;
  final bool? updateMandatory;
  final String? updateDetails;
  final bool messagePresent;
  final String? messageTitle, messageDetails;
  final bool? messageLinkPresent;
  final String? messageLinkName, messageLink;

  ClientResult(
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

  factory ClientResult.fromJson(String body) {
    dynamic json = jsonDecode(body);

    return ClientResult(
      json['updateAvailable'] as bool,
      json['updateNeeded'] as bool?,
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
