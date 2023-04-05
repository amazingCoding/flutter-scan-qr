import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'scan_qr_platform_interface.dart';

/// An implementation of [ScanQrPlatform] that uses method channels.
class MethodChannelScanQr extends ScanQrPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('scan_qr');

  @override
  Future<String?> openScanQr({required String color, required String title, required String content, required String confirmText, required String cancelText, required String errQrText}) async {
    return await methodChannel.invokeMethod<String>('openScanQr', {"color": color, "title": title, "content": content, "confirmText": confirmText, "cancelText": cancelText, "errQrText": errQrText});
  }
}
