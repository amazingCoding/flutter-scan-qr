import 'package:flutter_test/flutter_test.dart';
import 'package:scan_qr/scan_qr.dart';
import 'package:scan_qr/scan_qr_platform_interface.dart';
import 'package:scan_qr/scan_qr_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScanQrPlatform
    with MockPlatformInterfaceMixin
    implements ScanQrPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScanQrPlatform initialPlatform = ScanQrPlatform.instance;

  test('$MethodChannelScanQr is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScanQr>());
  });

  test('getPlatformVersion', () async {
    ScanQr scanQrPlugin = ScanQr();
    MockScanQrPlatform fakePlatform = MockScanQrPlatform();
    ScanQrPlatform.instance = fakePlatform;

    expect(await scanQrPlugin.getPlatformVersion(), '42');
  });
}
