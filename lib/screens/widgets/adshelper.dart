import 'dart:io';

class AdHelper {
  static String get getInterstatialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3617399600265414/6739232611';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3617399600265414/6739232611';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
