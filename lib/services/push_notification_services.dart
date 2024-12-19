import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  static String? token;
  // creat instance of fbm
  final firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<String>> fetchAllTokens() async {
    try {
      final querySnapshot = await firestore.collection('tokens').get();
      //
      final tokens =
          querySnapshot.docs.map((doc) => doc['token'] as String).toList();

      log("$tokens");
      return tokens;
    } catch (e) {
      print('Error fetching tokens: $e');
      return [];
    }
  }

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "taag-36265",
      "private_key_id": "00906c9b3997013bd426c23bda05a451230d30e2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDi9zBL184zDRsW\nG22262fb4xTAA2OoJTVyyMwjkVDInzrR4/66bVdbkxkwNEfWcpXZ7UOVDSCG7buz\ndGR/GpoMph7U2hcWipZBSsg5QTtBDX9zGssJTWDacHTHUq+a2KttUgghsLLCzugE\npNvu9KJFHQA/Uf57UU3VxiXd4LoGIPFGyYgwgXIth6wBHjDZt78wzwZ0DVcIscaT\nZEscsAv2eSXOEUm86w6UyMyUXWsQC91Jr4xOJFIYYR68Dogx1koGhSAUIZr2vmTl\niIXbpNwjhLnRGVDHKCvPkyLN1DSO6HD/gp6vLft5KOWLvSafZCx9LfkWPQyLZ6gI\n2NnPrXz9AgMBAAECggEAGhjBCV9xeqY9oI+b0GYF5Z8ZIjDhkxJgMGgNLOPHDaJd\nYYfdILN00Xc69LN2NR6sw0eIN0mwnUMVi39NFN5Kqzyom+HNuM5Lk4tVNVweQ48Z\nQfNpOBMZGVTH4KlNvri+EU5W2ATYsRSYUfxgu3uOcvLwNdeoMqa5E+T6MqZlzVFh\n5oOYGhQPuNKgp7wkGnuzIjR/dXeldxM8scu5xSbPwo9XW/YkqwiczLTxAJ9MvgWT\n8qhftHCU+uJsCHQfVy7/b8634D3M7Je5h/e3Diph36QXdEUY91Ta4XmABrHE9TWs\nO+tSuxJOCQOLgRs0JWswlYAMTcUKhe0fGGKYHmjvcwKBgQD5DAkS5ZucQtT6EPbG\nFYQnS0yhjuZAcF+h66Gz9AGgIH7thfQD/seRbbAEhh8DYPLQsRPPxQSxBRuGLppJ\nNKyqK0dgg3gbDIjjBZ0usNUjjEUYFZffvavXK16a0wRJoh2Zjs8fqRkTgzh5NCKI\n8p9tw7HU7LpyaF1Uwxbqs6KO5wKBgQDpTVW/G+iCXYNn81q0PqmGZ2YbPm3N65Sm\n+QrHpFJTIA0TzUldR5lUCP0r8x+Ytl/DmR+9zIhEbu7d6WU8uCcj7mV9bARJHu3n\n8EkjS5R9Fk6X60lG5YPMIOwivCgjoDa9f8QaiV4HQWxja1W+udqBG+HCf1Akl9Dk\n3I4gMyAMewKBgFtifzHf7um33E6mSucEnimNB+GAfhzHH1BbFkriDnajde/SZ2fP\n5YsHpL8EN/0VZgQN9icXNFGAfkkOcK7MFU+b8eUIWNoUD2a+eJ7ZZFxW7EOaKNCA\n2L1rvJszMy+RvSrLrFUBx6HRVLek2cdGwBmW5XosI343rYeczpvwroWhAoGBAMaG\noGi3fuswWBmk45JtoCRW6HRWc2m/Bgfv9FReaA+EPpyTG9LckoUIASfdAw4YYvU2\n3+PKoEpbe7gqW5OHwQa6XnKT8DGouBmeRx5ZukmXKdnsxbYmqDiT61zDcASg2PP4\nPQ+3xOO3sFwJgjWCQYWMDFhNrgz1gzS82dRcrPDxAoGBAMFlgn+lfGoRb0FV9qGp\n9r757axsEMGKJGt60R4Iz6Fz1yB+oW9FW31q3zv/oL8lYX9llS4XwjZ2ne54ockC\n/ZxrCAYCp/+cAkLDIG6SMe+Fl2VpkO04MsHWXXGYWpXOW4T2UEJtdIrcjfI8R7yH\nBFubJYchvcoMfnV5Js5vE//h\n-----END PRIVATE KEY-----\n",
      "client_email": "taag-fcm@taag-36265.iam.gserviceaccount.com",
      "client_id": "111113230436869417413",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/taag-fcm%40taag-36265.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      log("Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      log("Error getting access token: $e");
      return null;
    }
  }

  Future<void> sendNotificationToAll(String title, String body) async {
    final tokens = await fetchAllTokens();

    if (tokens.isEmpty) {
      log('No tokens found.');
      return;
    }

    final dio = Dio();

    // Firebase Cloud Messaging API URL
    const fcmUrl =
        'https://fcm.googleapis.com/v1/projects/taag-36265/messages:send';

    // Your server key (from Firebase project settings)
    var serverKey = await getAccessToken();

    // Set headers for the FCM request
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    for (final token in tokens) {
      final payload = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "android": {
            "notification": {
              "notification_priority": "PRIORITY_MAX",
              "sound": "default"
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "alert": {
                  "title": title,
                  "body": body,
                },
                "sound": "default",
                "badge": 1, // Optionally set badge count for iOS
              }
            },
            "headers": {
              "apns-priority": "10", // Immediate delivery priority for iOS
            }
          }
        }
      };
      try {
        final response = await dio.post(
          fcmUrl,
          options: Options(headers: headers),
          data: payload,
        );
        // Print response status code and body for debugging
        log('Response Status Code: ${response.statusCode}');
        //
        log('Notification sent to $token: ${response.data}');
      } catch (e) {
        log('Error sending notification to $token: $e');
        //
        log("Error sending notification: $e");
      }
    }
  }
}
