package com.app2m.weather

import android.os.Bundle
import android.util.Log
import com.amap.api.location.AMapLocation

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.ToastProviderPlugin
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationListener
import com.amap.api.location.AMapLocationClientOption
import io.flutter.plugins.AmapLocationPlugin
import io.flutter.plugins.PlatformVersionPlugin


class MainActivity: FlutterActivity() {
  //声明AMapLocationClient类对象
  private val mLocationClient: AMapLocationClient by lazy {
    //初始化定位
    AMapLocationClient(applicationContext)
  }
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    //注册Toast插件
    ToastProviderPlugin.register(this, this.flutterView)
    // 注册PlatformVersionPlugin插件
    PlatformVersionPlugin.registerWith(this.registrarFor(PlatformVersionPlugin.CHANNEL))
    // 注册定位插件
    AmapLocationPlugin.registerWith(this.registrarFor(AmapLocationPlugin.CHANNEL))


/*
    //设置定位回调监听
    mLocationClient.setLocationListener(object : AMapLocationListener {
      override fun onLocationChanged(p0: AMapLocation) {
        Log.d("app2m.AMAP", "onLocationChanged address====> ${p0.address}")
        Log.d("app2m.AMAP", "onLocationChanged city====> ${p0.city}(${p0.cityCode})")
      }

    })
    //声明AMapLocationClientOption对象
    var mLocationOption = AMapLocationClientOption()
    //设置定位模式为AMapLocationMode.Battery_Saving，低功耗模式。
    //低功耗定位模式：不会使用GPS和其他传感器，只会使用网络定位（Wi-Fi和基站定位）；
    mLocationOption.locationMode = AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
    //获取一次定位结果，该方法默认为false。
    mLocationOption.isOnceLocation = true
    //设置是否返回地址信息（默认返回地址信息）
    mLocationOption.isNeedAddress = true
    //设置定位间隔,单位毫秒,默认为2000ms，最低1000ms。
//    mLocationOption.interval = 1000

    //设置定位场景，目前支持三种场景（签到、出行、运动，默认无场景）
    //场景为SignIn(签到)时，不可连续定位。
    mLocationOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.SignIn)
    if(null != mLocationClient){
      mLocationClient.setLocationOption(mLocationOption)
      //设置场景模式后最好调用一次stop，再调用start以保证场景模式生效
      mLocationClient.stopLocation()
      mLocationClient.startLocation()
    }
*/
  }
}
