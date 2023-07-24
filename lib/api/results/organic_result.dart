import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';

import '../../local/history.dart';
import '../../pages/widgets/popups/quimify_loading.dart';
import '../../pages/widgets/popups/quimify_message_dialog.dart';
import '../../pages/widgets/popups/quimify_no_internet_dialog.dart';
import '../../utils/internet.dart';
import '../api.dart';

class OrganicResult {
  final bool present;

  final String? name, structure, url2D;
  final num? molecularMass;

  OrganicResult(
      this.present, this.structure, this.name, this.molecularMass, this.url2D);
  factory OrganicResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return OrganicResult(
        json['present'] as bool,
        json['structure'] as String?,
        json['name'] as String?,
        json['molecularMass'] as num?,
        json['url2D'] as String?);
  }

  @override
  String toString() {
    List<String?> identifiers = [
      structure,
      name,
      url2D,
      molecularMass.toString(),
    ];

    identifiers.removeWhere((identifier) => identifier == null);

    return identifiers.toString();
  }

  static Future<OrganicResult?> search(
      BuildContext context, String structure) async {
    startQuimifyLoading(context);
    OrganicResult? result = await Api().getOrganicFromName(structure);

    stopQuimifyLoading();

    if (result != null) {
      if (!result.present) {
        const QuimifyMessageDialog(title: 'Sin resultado')
            .showIn(context); //TODO, search why this warning

        return null;
      }
      // Saving organic Result to cache
      History.saveOrganic(result);
    } else {
      // Client already reported an error in this case
      hasInternetConnection().then(
        (bool hasInternetConnection) {
          if (hasInternetConnection) {
            const QuimifyMessageDialog(
              title: 'Sin resultado',
            ).showIn(context);
          } else {
            quimifyNoInternetDialog.showIn(context);
          }
        },
      );
    }

    return result;
  }
}
