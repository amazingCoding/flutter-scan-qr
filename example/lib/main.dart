import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:scan_qr/scan_qr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String address = '';
  @override
  void initState() {
    super.initState();
  }

  Future<void> open() async {
    try {
      var res = await ScanQr.openScanQr(
        color: "#15A9EC",
        title: "警告",
        content: "请打开相机权限",
        confirmText: "设置",
        cancelText: "取消",
        errQrText: "未找到二维码",
      );
      setState(() {
        address = res ?? '';
      });
      print(res);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(child: Text('qr scan: $address')),
          floatingActionButton: FloatingActionButton(
            onPressed: open,
            tooltip: 'open',
            child: const Icon(Icons.add),
          )),
    );
  }
}
