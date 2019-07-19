package io.flutter.plugins

import android.content.Context
import android.util.Log
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.google.gson.Gson
import com.google.gson.JsonParseException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class AmapLocationPlugin(context: Context): MethodChannel.MethodCallHandler {
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


    private fun location(result: MethodChannel.Result) {
        //设置定位回调监听
        mLocationClient.setLocationListener { location ->
            Log.d("app2m.AMAP", "onLocationChanged address====> ${location.address}")
            Log.d("app2m.AMAP", "onLocationChanged city====> ${location.city}(${location.cityCode})")
            if (location.city.isNullOrBlank()) {
                result.error(location.errorCode.toString(), location.errorInfo, null)
            } else {
                //字段是首字母小写，其余单词首字母大写
                try {
                    val locationData = AmapLocationData(location)
                    val strJson = Gson().toJson(locationData)
                    result.success(strJson)
                } catch (e: Exception) {
                    result.error("0", "AmapLocation 序列化错误", null)
                }
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