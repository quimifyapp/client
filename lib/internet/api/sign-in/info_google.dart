import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

// Returns Gender and Birthday from Google
Future<Map<String, String>> getInfoGoogle(
    GoogleSignInAccount googleUser) async {
  // Retrieve the authentication headers
  final Map<String, String> headers = await googleUser.authHeaders;

  // Safely handle the 'Authorization' header
  final String authorizationHeader = headers['Authorization'] ?? '';

  // Make the initial HTTP GET request to the Google People API
  final response = await http.get(
    Uri.parse(
        'https://people.googleapis.com/v1/people/me?personFields=genders,birthdays'), // Use your API key as needed
    headers: {'Authorization': authorizationHeader},
  );

  // Handle the response
  if (response.statusCode == 200) {
    // Decode the JSON response
    final data = jsonDecode(response.body);

    // Extract gender information
    String gender = 'Gender not found';
    if (data['genders'] != null && data['genders'].isNotEmpty) {
      gender = data['genders'][0]['formattedValue'];
    }

    // Extract birthday information
    String birthday = 'Birthday not found';
    bool yearMissing = false;

    if (data['birthdays'] != null && data['birthdays'].isNotEmpty) {
      final birthdayDate = data['birthdays'][0]['date'];
      if (birthdayDate != null) {
        int? year = birthdayDate['year'];
        int? month = birthdayDate['month'];
        int? day = birthdayDate['day'];

        if (year != null && month != null && day != null) {
          DateTime birthdayDateTime = DateTime(year, month, day);
          int timestamp = birthdayDateTime.millisecondsSinceEpoch;
          birthday = timestamp.toString();
        } else {
          yearMissing = year == null;
          birthday =
              '${year ?? ''}-${month != null ? month.toString().padLeft(2, '0') : ''}-${day != null ? day.toString().padLeft(2, '0') : ''}';
        }
      }
    }

    // If the year is missing, make another API call with age range
    if (yearMissing) {
      final rangedResponse = await http.get(
        Uri.parse(
            'https://people.googleapis.com/v1/people/me?personFields=ageRanges'),
        headers: {'Authorization': authorizationHeader},
      );

      if (rangedResponse.statusCode == 200) {
        final rangedData = jsonDecode(rangedResponse.body);
        if (rangedData['ageRanges'] != null &&
            rangedData['ageRanges'].isNotEmpty) {
          // Extract age range
          final ageRange = rangedData['ageRanges'][0]['ageRange'];
          if (ageRange != null) {
            birthday = ageRange;
          }
        }
      }
    }

    // Return both gender and birthday
    return {'gender': gender, 'birthday': birthday};
  } else {
    // Handle error cases
    throw Exception(
        'Failed to fetch gender and birthday info: ${response.statusCode}');
  }
}
