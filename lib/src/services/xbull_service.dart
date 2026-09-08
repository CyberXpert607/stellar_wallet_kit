import 'package:url_launcher/url_launcher.dart';


/// Service handling xBull deep‑link integration (SEP‑0007).
/// It builds a signing URL and launches it via [url_launcher].
class XBullService {
  final String callbackScheme;

  XBullService({this.callbackScheme = 'stellarwalletkit'});

  /// Build a SEP‑0007 URL for a transaction XDR.
  /// [xdr] is the base64‑encoded transaction XDR string.
  /// Returns the full URL to launch.
  String buildSignUrl({required String xdr, required String network}) {
    final uri = Uri(
      scheme: 'web+stellar',
      path: 'tx',
      queryParameters: {
        'xdr': xdr,
        'network': network,
        'callback': '${callbackScheme}://callback',
      },
    );
    return uri.toString();
  }

  /// Launch the signing flow.
  /// Returns true if the URL could be launched.
  Future<bool> launchSigning({required String signUrl}) async {
    if (await canLaunchUrl(Uri.parse(signUrl))) {
      await launchUrl(Uri.parse(signUrl), mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }
}
