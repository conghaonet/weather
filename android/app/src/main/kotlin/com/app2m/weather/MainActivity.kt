package com.app2m.weather

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.ToastProviderPlugin
import io.flutter.plugins.AmapLocationPlugin
import io.flutter.plugins.PlatformVersionPlugin


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    //注册Toast插件
    ToastProviderPlugin.register(this, this.flutterView)
    // 注册PlatformVersionPlugin插件
    PlatformVersionPlugin.registerWith(this.registrarFor(PlatformVersionPlugin.CHANNEL))
    // 注册定位插件
    AmapLocationPlugin.registerWith(this.registrarFor(AmapLocationPlugin.CHANNEL))
  }
}
