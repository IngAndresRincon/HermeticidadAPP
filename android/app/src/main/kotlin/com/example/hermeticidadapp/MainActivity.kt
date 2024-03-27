package com.example.hermeticidadapp

import android.content.Context
import android.content.Intent
import android.net.wifi.WifiManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings

class MainActivity: FlutterActivity() {
      private val CHANNEL = "com.example.hermeticidadapp"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        if (call.method == "openWifiSettings") {
            openWifiSettings()
            result.success(null)
        } 
        else if(call.method == "openMovileSettings"){
            openMovileSettings()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }
  }

  private fun openWifiSettings() {
      val intent = Intent(WifiManager.ACTION_PICK_WIFI_NETWORK)
      startActivity(intent)
  }

  private fun openMovileSettings() {
      val intent = Intent(Settings.ACTION_SETTINGS)
      startActivity(intent)
  }
}
