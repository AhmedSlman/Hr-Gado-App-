import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static launchGoogleMaps({required double lat, required double long}) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$long';
      url = 'comgooglemaps:/?saddr=&daddr=$lat,$long&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      cprint('Could not launch $url');
    }
  }

  static launchWhatsApp({required String phone, String? message}) async {
    String url() {
      return Platform.isAndroid
          ? "whatsapp://send?phone=$phone"
          : "https://wa.me/$phone";
    }

    await launchUrl(Uri.parse(url()));
  }

  static launchEmail(String email) async {
    if (await canLaunchUrl(Uri(scheme: 'mailto', path: email))) {
      await launchUrl(Uri(scheme: 'mailto', path: email));
    } else {
      cprint('Could not launch mailto:$email');
    }
  }

  static launchPhone(String phone) async {
    if (await canLaunchUrl(Uri.parse("tel:$phone"))) {
      await launchUrl(Uri(scheme: 'tel', path: phone));
    } else {
      cprint('Could not launch tel:$phone');
    }
  }

  static void logEvent(String event, {Map<String, dynamic>? parameter}) {
    kReleaseMode ? developer.log("message") : cprint("[EVENT]: $event");
  }
}

void cprint(dynamic data, {String? errorIn, String? event, String? label}) {
  if (kDebugMode) {
    if (errorIn != null) {
      print(
        '****************************** error ******************************',
      );
      developer.log(
        '[${label ?? "Error"}]',
        time: DateTime.now(),
        error: data,
        name: errorIn,
      );
      print(
        '****************************** error ******************************',
      );
    } else if (data != null) {
      developer.log(data, time: DateTime.now(), name: label ?? "Log");
    }
    if (event != null) {
      Utility.logEvent(event, parameter: {});
    }
  }
}
