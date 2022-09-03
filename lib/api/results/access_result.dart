import 'dart:convert';

class AccessResult {
  final bool updateAvailable,
      updateMandatory,
      messagePresent,
      messageLinkPresent;
  final String updateDetails,
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
      json['actualizacion_disponible'] as bool,
      json['actualizacion_obligatoria'] as bool,
      json['actualizacion_detalles'] as String,
      json['mensaje_presente'] as bool,
      json['mensaje_titulo'] as String,
      json['mensaje_detalles'] as String,
      json['mensaje_enlace_presente'] as bool,
      json['mensaje_enlace_nombre'] as String,
      json['mensaje_enlace'] as String,
    );
  }
}
