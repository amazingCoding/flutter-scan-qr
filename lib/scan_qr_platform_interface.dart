import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'scan_qr_method_channel.dart';

abstract class ScanQrPlatform extends PlatformInterface {
  /// Constructs a ScanQrPlatform.
  ScanQrPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScanQrPlatform _instance = MethodChannelScanQr();

  /// The default instance of [ScanQrPlatform] to use.
  ///
  /// Defaults to [MethodChannelScanQr].
  static ScanQrPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScanQrPlatform] when
  /// they register themselves.
  static set instance(ScanQrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> openScanQr({required String color, required String title, required String content, required String confirmText, required String cancelText, required String errQrText}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
