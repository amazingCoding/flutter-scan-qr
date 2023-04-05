import 'scan_qr_platform_interface.dart';

class ScanQr {
  static Future<String?> openScanQr({required String color, required String title, required String content, required String confirmText, required String cancelText, required String errQrText}) {
    return ScanQrPlatform.instance.openScanQr(color: color, title: title, content: content, confirmText: confirmText, cancelText: cancelText, errQrText: errQrText);
  }
}
