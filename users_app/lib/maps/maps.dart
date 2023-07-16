import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();

  static Future<void> openMapWithPosition(
      double latitude, double longitude) async {
    Uri googleMapUrl = Uri.parse(
        "https://google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw "Could not open google map";
    }
  }
  //text address

  static Future<void> openMapWithAddress(String fullAddress) async {
    String query = Uri.encodeComponent(fullAddress);
    Uri googleMapUrl =
        Uri.parse("https://google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw "Could not open google map";
    }
  }
}
