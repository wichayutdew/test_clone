package com.example.test_clone

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import android.app.NotificationManager
import android.content.Context

class Application : FlutterApplication(), PluginRegistrantCallback {

  override fun onCreate() {
    super.onCreate()
    FlutterFirebaseMessagingService.setPluginRegistrant(this)
  }
  override fun registerWith(registry: PluginRegistry?) {
    registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
  }
  
}