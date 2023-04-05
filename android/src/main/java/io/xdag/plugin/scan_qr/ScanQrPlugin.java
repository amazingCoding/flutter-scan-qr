package io.xdag.plugin.scan_qr;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** ScanQrPlugin */
public class ScanQrPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Result result;
  private Activity activity;
  private final static String TAG = "ScanQrPlugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "scan_qr");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("openScanQr")) {
      if (!activity.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)) {
        result.error("no_camera", "No camera available on device", null);
        return;
      }
      this.result = result;
      Map<String, Object> data = call.arguments();
      String color = (String) data.get("color");
      String title = (String) data.get("title");
      String content = (String) data.get("content");
      String confirmText = (String) data.get("confirmText");
      String cancelText = (String) data.get("cancelText");
      String errQrText = (String) data.get("errQrText");
      Intent intent = new Intent(activity, ScanActivity.class);
      intent.putExtra("color",color);
      intent.putExtra("title",title);
      intent.putExtra("content",content);
      intent.putExtra("confirmText",confirmText);
      intent.putExtra("cancelText",cancelText);
      intent.putExtra("errQrText",errQrText);

      activity.startActivityForResult(intent, 1);
      activity.overridePendingTransition(R.anim.push_bottom, R.anim.normal_bottom);

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  //
  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  //
  @Override
  public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent intent) {
    if (requestCode == 1) {
      if (result != null) {
        if (resultCode == Activity.RESULT_CANCELED) {
          result.error("Cancelled", "User cancelled scan", null);
        } else if (resultCode == Activity.RESULT_OK) {
          String res = intent.getStringExtra("result");
          result.success(res);
        }
      }
    }
    result = null;
    return false;
  }
}
