package io.flutter.plugins

import android.content.Context
import android.util.Log
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class AmapLocationPlugin(val context: Context): MethodChannel.MethodCallHandler {
    companion object {
        /** Channel名称  **/
        const val CHANNEL = "app2m.com/location"
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL)
            channel.setMethodCallHandler(AmapLocationPlugin(registrar.context().applicationContext))
        }
    }
    private var mLocationClient: AMapLocationClient = AMapLocationClient(context)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getLocation") {
            location(result)
        } else if (call.method == "stopLocation") {
            mLocationClient.stopLocation()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }


    private fun location(result: MethodChannel.Result? = null) {
        //设置定位回调监听
        mLocationClient.setLocationListener { listener ->
            Log.d("app2m.AMAP", "onLocationChanged address====> ${listener.address}")
            Log.d("app2m.AMAP", "onLocationChanged city====> ${listener.city}(${listener.cityCode})")
            if (listener.city.isNullOrBlank()) {
                result?.error(listener.errorCode.toString(), listener.errorInfo, null)
            } else {
                result?.success(listener.city)
            }
        }
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
        //mLocationOption.interval = 1000

        //设置定位场景，目前支持三种场景（签到、出行、运动，默认无场景）
        //场景为SignIn(签到)时，不可连续定位。
        mLocationOption.locationPurpose = AMapLocationClientOption.AMapLocationPurpose.SignIn
        mLocationClient.setLocationOption(mLocationOption)

        //设置场景模式后最好调用一次stop，再调用start以保证场景模式生效
        mLocationClient.stopLocation()
        mLocationClient.startLocation()
    }

}